import 'package:flutter/material.dart';
import 'animated_scale_button.dart';
import '../providers/theme_provider.dart';

/// CustomAppBar - Replaces Material AppBar with custom design
///
/// React equivalent: Custom Row with Padding (top: 60, left: 24, right: 24)
/// - No Material overhead
/// - Exact padding matching the Figma/React design
/// - Optional back button and title
class CustomAppBar extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final Widget? leading;
  final double topPadding;
  final bool sticky;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBack,
    this.trailing,
    this.leading,
    this.topPadding = 60,
    this.sticky = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      decoration: sticky
          ? BoxDecoration(
              color: isDark
                  ? AppColors.scaffoldBackgroundDark
                  : AppColors.scaffoldBackgroundLight,
            )
          : null,
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (onBack != null)
            AnimatedScaleButton(
              onTap: onBack,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardBackgroundDark
                      : AppColors.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF333333)
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            )
          else
            const SizedBox(width: 48),
          if (title != null) ...[
            const SizedBox(width: 16),
            Text(
              title!,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// IconButton variant for header actions (Help, Bell, etc.)
class HeaderIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final int? badgeCount;

  const HeaderIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScaleButton(
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.cardBackgroundDark
                    : AppColors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  size: 24,
                ),
                child: icon,
              ),
            ),
            if (badgeCount != null && badgeCount! > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.orangeAccent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.scaffoldBackgroundDark
                          : AppColors.scaffoldBackgroundLight,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
