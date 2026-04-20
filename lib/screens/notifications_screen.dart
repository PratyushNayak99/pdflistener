import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../models/notification_item.dart';
import '../widgets/animated_scale_button.dart';

/// NotificationsScreen - Updates and notifications list
///
/// React equivalent: NotificationsScreen with unread indicators
/// - Mark all read functionality
/// - Unread badge indicators
/// - Icon based on notification type
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final notifications = ref.watch(notificationsProvider);

    return Container(
      color: isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackgroundLight,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(isDark, ref),
            ),
            // Notifications List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final notif = notifications[index];
                    return _buildNotificationCard(notif, isDark, ref, index);
                  },
                  childCount: notifications.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
      child: Row(
        children: [
          AnimatedScaleButton(
            onTap: () => ref.navigateTo(AppScreen.home),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 24,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Updates',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => ref.read(notificationsProvider.notifier).markAllRead(),
            child: const Text(
              'Mark All Read',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationItem notif,
    bool isDark,
    WidgetRef ref,
    int index,
  ) {
    IconData getIcon() {
      if (notif.title.contains('Complete')) return LucideIcons.fileAudio;
      if (notif.title.contains('Storage')) return LucideIcons.folder;
      if (notif.title.contains('Feature')) return LucideIcons.moon;
      return LucideIcons.activity;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: notif.unread
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : isDark
                      ? Colors.black
                      : const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Icon(
              getIcon(),
              size: 22,
              
              color: notif.unread
                  ? AppColors.primaryBlue
                  : isDark
                      ? AppColors.gray400
                      : const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                          color: (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight)
                              .withOpacity(notif.unread ? 1.0 : 0.8),
                        ),
                      ),
                    ),
                    if (notif.unread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notif.message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: notif.unread
                        ? isDark
                            ? const Color(0xFFCCCCCC)
                            : const Color(0xFF4B5563)
                        : AppColors.gray400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notif.time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: notif.unread
                        ? AppColors.primaryBlue
                        : AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50))
        .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: index * 50));
  }
}
