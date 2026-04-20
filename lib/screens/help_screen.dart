import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../widgets/animated_scale_button.dart';
import '../models/notification_item.dart';

/// HelpScreen - Help & Support screen
///
/// React equivalent: HelpScreen with support options
/// - FAQ, Billing, Contact Us buttons
/// - About app section with version info
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackgroundLight,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(isDark, ref),
            ),
            // Support Options
            SliverToBoxAdapter(
              child: _buildSupportOptions(isDark),
            ),
            // About App
            SliverToBoxAdapter(
              child: _buildAboutSection(isDark),
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
            onTap: () => ref.read(currentScreenProvider.notifier).state = AppScreen.home,
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
            'Help & Support',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOptions(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSupportItem(
            isDark: isDark,
            icon: LucideIcons.info,
            title: 'FAQ',
            subtitle: 'Common questions about formats',
            onTap: () {
              // Navigate to FAQ
            },
          ),
          _buildDivider(isDark),
          _buildSupportItem(
            isDark: isDark,
            icon: LucideIcons.creditCard,
            title: 'Billing Support',
            subtitle: 'Manage your subscription',
            onTap: () {
              // Navigate to Billing
            },
          ),
          _buildDivider(isDark),
          _buildSupportItem(
            isDark: isDark,
            icon: LucideIcons.helpCircle,
            title: 'Contact Us',
            subtitle: 'Email our support team directly',
            onTap: () {
              // Navigate to Contact
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AnimatedScaleButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 22,
                
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.gray400,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: const Icon(
              LucideIcons.headphones,
              size: 40,
              
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'PDF Listener App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 2.0.4 (Build 492)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray400,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Open privacy policy
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Privacy Policy',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  LucideIcons.externalLink,
                  size: 14,
                  color: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
