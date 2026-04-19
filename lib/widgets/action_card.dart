import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';

/// ActionCard - Dashboard action cards (Convert, Library, Recent)
///
/// React equivalent: ActionCard component with motion.div
/// - GridView layout with 2 columns
/// - Fade in + slide up animation on appear
/// - Scale down on tap
class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback? onClick;
  final bool centered;
  final Duration delay;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onClick,
    this.centered = false,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: centered
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: centered
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF333333)
                    : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF444444)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  size: 26,
                ),
                child: icon,
              ),
            ),
            if (!centered) const SizedBox(height: 12),
            if (centered) const SizedBox(height: 12),
            Text(
              title,
              textAlign: centered ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: centered ? TextAlign.center : TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.gray400,
              ),
            ),
          ],
        ),
      )
      .animate()
      .fadeIn(duration: 400.ms, delay: delay)
      .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: delay);
  }
}
