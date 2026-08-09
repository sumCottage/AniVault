import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AniListAuthService {
  static String get clientId => dotenv.env['ANILIST_CLIENT_ID'] ?? '';
  static String get clientSecret => dotenv.env['ANILIST_CLIENT_SECRET'] ?? '';
  static const String redirectUri = 'aniflux://anilist-auth';
  static const String _tokenKey = 'anilist_access_token';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static Future<void> login() async {
    final String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';

    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch AniList Auth URL');
    }
  }

  static Future<void> exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse('https://anilist.co/api/v2/oauth/token'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        await saveToken(accessToken);
      } else {
        throw Exception('Access token not found in response');
      }
    } else {
      throw Exception('Failed to exchange token: ${response.body}');
    }
  }

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  static Future<void> fetchAndSaveUserProfile() async {
    final token = await getToken();
    if (token == null) return;

    final response = await http.post(
      Uri.parse('https://graphql.anilist.co'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'query': '''
          query {
            Viewer {
              name
              avatar {
                large
              }
            }
          }
        '''
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final viewer = data['data']?['Viewer'];
      if (viewer != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('anilist_username', viewer['name'] ?? '');
        await prefs.setString('anilist_avatar', viewer['avatar']?['large'] ?? '');
      }
    }
  }

  static Future<Map<String, String>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('anilist_username');
    final avatar = prefs.getString('anilist_avatar');
    if (username != null && username.isNotEmpty) {
      return {'username': username, 'avatar': avatar ?? ''};
    }
    return null;
  }

  static Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('anilist_username');
    await prefs.remove('anilist_avatar');
  }
}
