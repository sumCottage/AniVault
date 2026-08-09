import 'dart:async';
import 'package:ainme_vault/services/anilist_auth_service.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AniListRatingSection extends StatefulWidget {
  final double? userScore; // 0.0 to 10.0 or null
  final ValueChanged<double?> onRatingChanged;
  final bool isAniListConnected;
  final VoidCallback? onAniListConnected;

  const AniListRatingSection({
    super.key,
    required this.userScore,
    required this.onRatingChanged,
    required this.isAniListConnected,
    this.onAniListConnected,
  });

  @override
  State<AniListRatingSection> createState() => _AniListRatingSectionState();
}

class _AniListRatingSectionState extends State<AniListRatingSection> {
  StreamSubscription<Uri>? _appLinksSubscription;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isAniListConnected) {
      _initDeepLinkListener();
    }
  }

  @override
  void dispose() {
    _appLinksSubscription?.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    final appLinks = AppLinks();
    _appLinksSubscription = appLinks.uriLinkStream.listen((uri) async {
      if (uri.scheme == 'aniflux' && uri.host == 'anilist-auth') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          try {
            if (mounted) setState(() => _isConnecting = true);
            await AniListAuthService.exchangeCodeForToken(code);
            await AniListAuthService.fetchAndSaveUserProfile();
            if (mounted) {
              setState(() => _isConnecting = false);
              widget.onAniListConnected?.call();
            }
          } catch (e) {
            if (mounted) {
              setState(() => _isConnecting = false);
            }
          }
        }
      }
    });
  }

  Future<void> _connectAniList() async {
    HapticFeedback.lightImpact();
    try {
      await AniListAuthService.login();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open AniList login: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Your Rating",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF02A9FF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "AniList",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF02A9FF),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.isAniListConnected)
              _buildRatingBadge()
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Locked",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.isAniListConnected)
          _buildConnectedRatingView()
        else
          _buildLockedView(),
      ],
    );
  }

  Widget _buildRatingBadge() {
    final hasScore = widget.userScore != null && widget.userScore! > 0;
    final intScore = widget.userScore?.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: hasScore
                ? const Color(0xFF02A9FF).withValues(alpha: 0.15)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasScore
                  ? const Color(0xFF02A9FF).withValues(alpha: 0.4)
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasScore ? Icons.star_rounded : Icons.star_outline_rounded,
                color: hasScore ? const Color(0xFF02A9FF) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                hasScore ? "$intScore/10" : "Not Rated",
                style: TextStyle(
                  color: hasScore
                      ? const Color(0xFF02A9FF)
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (hasScore) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onRatingChanged(null);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConnectedRatingView() {
    final currentScore = (widget.userScore?.round() ?? 0).toDouble();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 10 Stars selector (1 to 10 integer scale)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (index) {
              final starValue = (index + 1).toDouble();
              final isFilled = currentScore >= starValue;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (currentScore == starValue) {
                    widget.onRatingChanged(null); // Tapping same star unselects
                  } else {
                    widget.onRatingChanged(starValue);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
                  child: Icon(
                    isFilled
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: isFilled
                        ? const Color(0xFF02A9FF)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
                    size: 26,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Slider for integer scale (0 to 10)
          Row(
            children: [
              Text(
                "0",
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF02A9FF),
                    inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    thumbColor: const Color(0xFF02A9FF),
                    overlayColor: const Color(0xFF02A9FF).withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: currentScore.clamp(0.0, 10.0),
                    min: 0.0,
                    max: 10.0,
                    divisions: 10, // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
                    onChanged: (value) {
                      final intVal = value.round();
                      if (intVal != currentScore.round()) {
                        HapticFeedback.lightImpact();
                      }
                      widget.onRatingChanged(intVal == 0 ? null : intVal.toDouble());
                    },
                  ),
                ),
              ),
              Text(
                "10",
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.sync_rounded,
                size: 13,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 4),
              Text(
                "Will be synced to your AniList profile",
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLockedView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF02A9FF).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xFF02A9FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rating Locked",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Connect AniList account for rating and contributing to score counting.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isConnecting ? null : _connectAniList,
              icon: _isConnecting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.link_rounded, size: 18),
              label: Text(
                _isConnecting ? "Connecting…" : "Connect AniList Account",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF02A9FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
