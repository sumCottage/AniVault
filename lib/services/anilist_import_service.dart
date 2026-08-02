import 'package:ainme_vault/services/anilist_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AniListImportService {
  static const String _userListQuery = r'''
    query ($userId: Int, $userName: String) {
      MediaListCollection(userId: $userId, userName: $userName, type: ANIME) {
        lists {
          name
          isCustomList
          entries {
            status
            score(format: POINT_100)
            progress
            repeat
            createdAt
            startedAt {
              year
              month
              day
            }
            completedAt {
              year
              month
              day
            }
            media {
              id
              title {
                romaji
                english
              }
              coverImage {
                large
              }
              format
              episodes
              averageScore
              status
              duration
              seasonYear
            }
          }
        }
      }
    }
  ''';

  static const String _viewerQuery = r'''
    query {
      Viewer {
        id
        name
      }
    }
  ''';

  static Future<GraphQLClient> _getAuthenticatedClient() async {
    final token = await AniListAuthService.getToken();
    if (token == null) {
      throw Exception('Not authenticated with AniList');
    }

    final HttpLink httpLink = HttpLink('https://graphql.anilist.co');
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  static Future<Map<String, dynamic>> fetchUserList() async {
    final client = await _getAuthenticatedClient();

    // First get the viewer ID
    final viewerResult = await client.query(
      QueryOptions(
        document: gql(_viewerQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (viewerResult.hasException) {
      throw Exception(
        'Failed to fetch Viewer ID: ${viewerResult.exception.toString()}',
      );
    }

    final userId = viewerResult.data?['Viewer']?['id'];
    if (userId == null) {
      throw Exception('Could not determine AniList User ID');
    }

    // Now fetch the lists
    final listResult = await client.query(
      QueryOptions(
        document: gql(_userListQuery),
        variables: {'userId': userId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (listResult.hasException) {
      throw Exception(
        'Failed to fetch MediaListCollection: ${listResult.exception.toString()}',
      );
    }

    return listResult.data ?? {};
  }

  static Future<int> importToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not logged into Firebase');
    }

    final data = await fetchUserList();
    final lists = data['MediaListCollection']?['lists'] as List<dynamic>?;

    if (lists == null || lists.isEmpty) return 0;

    int totalImported = 0;
    final batch = FirebaseFirestore.instance.batch();

    // Process in batches if necessary, but Firestore batch supports up to 500 writes
    // For simplicity, we loop through and commit every 500 entries
    int batchCount = 0;
    WriteBatch currentBatch = FirebaseFirestore.instance.batch();

    for (var list in lists) {
      final entries = list['entries'] as List<dynamic>?;
      if (entries == null) continue;

      for (var entry in entries) {
        final media = entry['media'];
        if (media == null) continue;

        final animeId = media['id'].toString();
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('anime')
            .doc(animeId);

        final title =
            media['title']['english'] ?? media['title']['romaji'] ?? 'Unknown';
        final coverImage = media['coverImage']['large'] ?? '';
        final status = _mapAniListStatus(entry['status']);
        final progress = entry['progress'] ?? 0;
        final totalEpisodes = media['episodes'] ?? 0;

        final format = media['format'];
        final episodeDuration = (format == 'MOVIE')
            ? (media['duration'] ?? 90)
            : (media['duration'] ?? 24);
        final watchMinutes = progress * episodeDuration;

        final docData = {
          'id': media['id'],
          'title': title,
          'coverImage': coverImage,
          'status': status,
          'progress': progress,
          'totalEpisodes': totalEpisodes,
          'averageScore': media['averageScore'],
          'userScore': entry['score'],
          'lastUpdated': FieldValue.serverTimestamp(),
          'format': format,
          'seasonYear': media['seasonYear'],
          'releaseStatus': media['status'],
          'episodeDuration': episodeDuration,
          'watchMinutes': watchMinutes,
        };

        DateTime? startDate;
        final startedAt = entry['startedAt'];
        if (startedAt != null && startedAt['year'] != null) {
          startDate = DateTime(
            startedAt['year'],
            startedAt['month'] ?? 1,
            startedAt['day'] ?? 1,
          );
        } else if (entry['createdAt'] != null) {
          startDate = DateTime.fromMillisecondsSinceEpoch(
            entry['createdAt'] * 1000,
          );
        }

        DateTime? finishDate;
        final completedAt = entry['completedAt'];
        if (completedAt != null && completedAt['year'] != null) {
          finishDate = DateTime(
            completedAt['year'],
            completedAt['month'] ?? 1,
            completedAt['day'] ?? 1,
          );
        }

        if (startDate != null) {
          docData['startDate'] = Timestamp.fromDate(startDate);
        }
        if (finishDate != null) {
          docData['finishDate'] = Timestamp.fromDate(finishDate);
        }

        currentBatch.set(docRef, docData, SetOptions(merge: true));
        batchCount++;
        totalImported++;

        if (batchCount == 500) {
          await currentBatch.commit();
          currentBatch = FirebaseFirestore.instance.batch();
          batchCount = 0;
        }
      }
    }

    if (batchCount > 0) {
      await currentBatch.commit();
    }

    return totalImported;
  }

  static String _mapAniListStatus(String? anilistStatus) {
    switch (anilistStatus) {
      case 'CURRENT':
        return 'Watching';
      case 'COMPLETED':
        return 'Completed';
      case 'PLANNING':
        return 'Planning';
      case 'DROPPED':
        return 'Dropped';
      case 'PAUSED':
        return 'Paused';
      case 'REPEATING':
        return 'Watching'; // Or another state if supported
      default:
        return 'Planning';
    }
  }
}
