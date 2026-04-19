import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_scale_button.dart';

/// PlayerScreen - Full-screen audio player
///
/// React equivalent: PlayerScreen with playback controls
/// - Album art with animated waveform
/// - Progress bar with drag
/// - Play/pause, skip, speed control
/// - Bookmark toggle
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _speed = 1.0;
  bool _bookmarked = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 12, seconds: 45);
  bool _isDragging = false;
  Duration _dragPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // For demo purposes, we're not loading actual audio
    // In production: await _audioPlayer.setAsset('assets/audio/sample.mp3');

    _audioPlayer.positionStream.listen((position) {
      if (!_isDragging && mounted) {
        setState(() => _position = position);
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && mounted) {
        setState(() => _totalDuration = duration);
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    final mins = duration.inMinutes;
    final secs = duration.inSeconds.remainder(60);
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _seekTo(double position) {
    final newPosition = Duration(milliseconds: (position * _totalDuration.inMilliseconds).round());
    setState(() => _position = newPosition);
    _audioPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayPosition = _isDragging ? _dragPosition : _position;
    final progressPercent = _totalDuration.inMilliseconds > 0
        ? displayPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    return Container(
      color: isDark ? Colors.black : const Color(0xFF1C1C1E),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isDark),
            // Album Art
            Expanded(
              child: _buildAlbumArt(isDark),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Design_Document_v2.pdf',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      height: 1.2,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chapter 1 - Introduction',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Progress Bar
            _buildProgressBar(isDark, progressPercent, displayPosition),
            const SizedBox(height: 24),
            // Controls
            _buildControls(isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedScaleButton(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            'NOW PLAYING',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white54,
            ),
          ),
          AnimatedScaleButton(
            onTap: () {
              // Settings tapped
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                LucideIcons.settings,
                size: 22,
                strokeWidth: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(bool isDark) {
    return Center(
      child: AnimatedScale(
        scale: _isPlaying ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(48),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated waveform bars
              if (_isPlaying)
                ...List.generate(5, (i) {
                  return Positioned(
                    left: 20 + i * 15,
                    child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1200 + i * 150),
                      tween: Tween<double>(begin: 0.2, end: 0.8),
                      builder: (context, value, child) {
                        return Container(
                          width: 8,
                          height: 200 * value,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  );
                }),
              // Headphones icon
              Icon(
                LucideIcons.headphones,
                size: 80,
                strokeWidth: 1.5,
                color: _isPlaying ? Colors.white : Colors.white.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(bool isDark, double progressPercent, Duration position) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GestureDetector(
            onHorizontalDragStart: (details) {
              setState(() {
                _isDragging = true;
                _dragPosition = _position;
              });
            },
            onHorizontalDragUpdate: (details) {
              final renderBox = context.findRenderObject() as RenderBox;
              final tapPosition = details.localPosition.dx;
              final newPercent = tapPosition / renderBox.size.width;
              setState(() {
                _dragPosition = Duration(
                  milliseconds: (newPercent * _totalDuration.inMilliseconds).round(),
                );
              });
            },
            onHorizontalDragEnd: (details) {
              final renderBox = context.findRenderObject() as RenderBox;
              final tapPosition = details.localPosition.dx;
              final newPercent = tapPosition / renderBox.size.width;
              _seekTo(newPercent);
              setState(() => _isDragging = false);
            },
            child: Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: FractionallySizedBox(
                        widthFactor: progressPercent,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(_isDragging ? _dragPosition : _position),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                ),
              ),
              Text(
                _formatTime(_totalDuration),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Speed button
          AnimatedScaleButton(
            onTap: () {
              setState(() {
                _speed = _speed == 1.0 ? 1.5 : (_speed == 1.5 ? 2.0 : 1.0);
                _audioPlayer.setSpeed(_speed);
              });
            },
            child: Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_speed}x',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Skip back, Play/Pause, Skip forward
          Row(
            children: [
              AnimatedScaleButton(
                onTap: () {
                  final newPosition = Duration(
                    milliseconds: (_position.inMilliseconds - 15000).clamp(
                      0,
                      _totalDuration.inMilliseconds,
                    ),
                  );
                  _audioPlayer.seek(newPosition);
                },
                child: const Icon(
                  LucideIcons.rewind,
                  size: 32,
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 24),
              AnimatedScaleButton(
                onTap: () {
                  if (_isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                },
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? LucideIcons.pause : LucideIcons.play,
                    size: 36,
                    strokeWidth: 1.5,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              AnimatedScaleButton(
                onTap: () {
                  final newPosition = Duration(
                    milliseconds: (_position.inMilliseconds + 15000).clamp(
                      0,
                      _totalDuration.inMilliseconds,
                    ),
                  );
                  _audioPlayer.seek(newPosition);
                },
                child: const Icon(
                  LucideIcons.fastForward,
                  size: 32,
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Bookmark button
          AnimatedScaleButton(
            onTap: () => setState(() => _bookmarked = !_bookmarked),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _bookmarked
                    ? AppColors.primaryBlue
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                LucideIcons.bookmark,
                size: 22,
                strokeWidth: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
