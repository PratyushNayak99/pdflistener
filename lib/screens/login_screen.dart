import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_scale_button.dart';

/// LoginScreen - Onboarding/Login screen
///
/// React equivalent: LoginScreen component with motion.div
/// - Decorative SVG line background
/// - Giant quirky typography
/// - Document card with animated waveform
/// - Floating headphones icon
class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Stack(
        children: [
          // Decorative clean line background (SVG replacement)
          Positioned.fill(
            child: CustomPaint(
              painter: DecorativeLinePainter(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 32, right: 32),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // Giant Quirky Typography
                        _buildTitle(isDark)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        // Minimalist Graphic Illustration
                        Expanded(
                          child: _buildIllustration(isDark)
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 200.ms)
                              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 400.ms),
                        ),
                      ],
                    ),
                  ),
                  // Call to Action
                  _buildCTA(isDark)
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Listen to\ndocuments\nanytime with\nPDF Audio',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w500,
          letterSpacing: -1.0,
          height: 0.95,
          color: isDark ? Colors.white : const Color(0xFF1C1C1E),
        ),
      ),
    );
  }

  Widget _buildIllustration(bool isDark) {
    return Center(
      child: SizedBox(
        width: 208,
        height: 240,
        child: Stack(
          children: [
            // Document Card Base
            Positioned.fill(
              child: AnimatedScaleButton(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1C1C1E)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1C1C1E)
                          : const Color(0xFF1C1C1E),
                      width: 5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : const Color(0xFF1C1C1E),
                        blurRadius: 0,
                        offset: const Offset(10, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.fileText,
                        size: 64,
                                                color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                      ),
                      const SizedBox(height: 24),
                      // Animated Audio Waveform inside the Doc
                      _buildWaveform(isDark),
                    ],
                  ),
                ),
              ),
            ),
            // Floating Detail (Headphones)
            Positioned(
              bottom: -24,
              right: -24,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF666666)
                        : const Color(0xFF1C1C1E),
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : const Color(0xFF1C1C1E),
                      blurRadius: 0,
                      offset: const Offset(6, 6),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  LucideIcons.headphones,
                  size: 36,
                  color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .moveY(begin: 0, end: -10, duration: 2.seconds)
                  .then()
                  .moveY(begin: -10, end: 0, duration: 2.seconds),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveform(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final isPrimary = i == 2 || i == 4;
        return Container(
          width: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.primaryBlue
                : isDark
                    ? Colors.white
                    : const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 1200 + i * 150),
            tween: Tween<double>(begin: 0.2, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scaleY: value,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? AppColors.primaryBlue
                        : isDark
                            ? Colors.white
                            : const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            },
            onEnd: () {
              // Restart animation via parent repeater
            },
          ),
        );
      }),
    );
  }

  Widget _buildCTA(bool isDark) {
    return Column(
      children: [
        AnimatedScaleButton(
          onTap: onLogin,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
                Icon(
                  LucideIcons.arrowRight,
                  size: 24,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Read and listen to any document.',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.gray400,
          ),
        ),
      ],
    );
  }
}

/// CustomPainter for decorative background lines
class DecorativeLinePainter extends CustomPainter {
  final Color color;

  DecorativeLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Line 1
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.25,
      size.width,
      size.height * 0.3,
    );

    // Line 2
    path.moveTo(0, size.height * 0.35);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width,
      size.height * 0.35,
    );

    // Line 3
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.35,
      size.width,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
