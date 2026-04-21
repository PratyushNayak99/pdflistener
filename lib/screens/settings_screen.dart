import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../router/app_router.dart';
import '../widgets/animated_scale_button.dart';

/// SettingsScreen - Profile, preferences, and app settings
///
/// React equivalent: SettingsScreen with editable profile, dark mode toggle
/// - Profile card with edit functionality
/// - Dark mode toggle with spring animation
/// - Notifications toggle
/// - Storage usage display
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isEditingProfile = false;
  bool _notificationsEnabled = true;
  late final TextEditingController _nameController;
  final TextEditingController _emailController = TextEditingController(text: 'alex@example.com');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(userNameProvider));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(isDark),
            ),
            // Profile Card
            SliverToBoxAdapter(
              child: _buildProfileCard(isDark),
            ),
            // Preferences Section
            SliverToBoxAdapter(
              child: _buildPreferencesSection(isDark, themeMode),
            ),
            // Storage Section
            SliverToBoxAdapter(
              child: _buildStorageSection(isDark),
            ),
            // Logout Button
            SliverToBoxAdapter(
              child: _buildLogoutButton(isDark),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
      child: Row(
        children: [
          AnimatedScaleButton(
            onTap: () => context.navigateTo(AppScreen.home),
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
              child: Icon(
                Icons.chevron_left,
                size: 24,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Settings',
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

  Widget _buildProfileCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.user,
                  size: 32,
                  
                  color: AppColors.primaryBlue,
                ),
              ),
              AnimatedScaleButton(
                onTap: () {
                  if (_isEditingProfile) {
                    final newName = _nameController.text;
                    ref.read(userNameProvider.notifier).state = newName;
                    ref.read(sharedPreferencesProvider).setString('userName', newName);
                  }
                  setState(() => _isEditingProfile = !_isEditingProfile);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isEditingProfile
                        ? (isDark ? Colors.white : const Color(0xFF1C1C1E))
                        : (isDark ? const Color(0xFF333333) : const Color(0xFFF2F2F7)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isEditingProfile ? 'Save' : 'Edit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _isEditingProfile
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white : const Color(0xFF1C1C1E)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isEditingProfile ? _buildEditFields(isDark) : _buildViewFields(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildEditFields(bool isDark) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.black : const Color(0xFFF8F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.gray400,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.black : const Color(0xFFF8F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildViewFields(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _nameController.text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _emailController.text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.gray400,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(bool isDark, ThemeMode themeMode) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Text(
              'PREFERENCES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.gray400,
              ),
            ),
          ),
          Container(
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
                _buildToggleRow(
                  isDark: isDark,
                  icon: themeMode == ThemeMode.dark
                      ? LucideIcons.moon
                      : LucideIcons.sun,
                  label: 'Dark Mode',
                  isOn: themeMode == ThemeMode.dark,
                  onToggle: () => ref.read(themeProvider.notifier).toggleTheme(),
                  showBorder: true,
                ),
                _buildToggleRow(
                  isDark: isDark,
                  icon: LucideIcons.bell,
                  label: 'Notifications',
                  isOn: _notificationsEnabled,
                  onToggle: () => setState(() => _notificationsEnabled = !_notificationsEnabled),
                  showBorder: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required bool isDark,
    required IconData icon,
    required String label,
    required bool isOn,
    required VoidCallback onToggle,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: showBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 22,
              
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: isOn ? AppColors.primaryBlue : (isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: isOn ? 28 : 4,
                    top: 4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Text(
              'STORAGE USAGE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.gray400,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.black : const Color(0xFFF8F9FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.folder,
                            size: 20,
                            
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Audio Files',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '1.2 GB ',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          TextSpan(
                            text: '/ 5 GB',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 0, end: 0.24),
                  builder: (context, value, child) {
                    return Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FractionallySizedBox(
                                widthFactor: value,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: AnimatedScaleButton(
        onTap: () => context.navigateTo(AppScreen.login),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark ? const Color(0xFF663333) : const Color(0xFFFFEBEE),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.logOut,
                size: 22,
                
                color: Color(0xFFFF3B30),
              ),
              const SizedBox(width: 8),
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                  color: Color(0xFFFF3B30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
