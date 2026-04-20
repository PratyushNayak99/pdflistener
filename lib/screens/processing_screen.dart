import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';

/// ProcessingScreen - Conversion animation screen
///
/// React equivalent: ProcessingScreen with concentric pulse circles
/// - 3 expanding/fading circles
/// - Center icon
/// - Auto-navigate to player after 2.5 seconds
class ProcessingScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const ProcessingScreen({super.key, required this.onComplete});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-complete after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      color: isDark ? AppColors.scaffoldBackgroundDark : const Color(0xFFF8F9FB),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulse Animation Container
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circle 1
                  _buildPulseCircle(isDark, 0),
                  // Circle 2
                  _buildPulseCircle(isDark, 600),
                  // Circle 3
                  _buildPulseCircle(isDark, 1200),
                  // Center Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.fileAudio,
                      size: 28,
                      
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // Status Text
            Text(
              'Converting your PDF...',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Extracting audio tracks',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseCircle(bool isDark, int delayMs) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.white : const Color(0xFF1C1C1E),
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          duration: const Duration(milliseconds: 2000),
          begin: const Offset(1, 1),
          end: const Offset(1.8, 1.8),
        )
        .fadeOut(
          duration: const Duration(milliseconds: 2000),
        )
        .then()
        .fadeIn(duration: Duration.zero);
  }
}
