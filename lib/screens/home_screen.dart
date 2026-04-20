import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../models/file_item.dart';
import '../widgets/animated_scale_button.dart';
import '../widgets/action_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/custom_app_bar.dart';

/// HomeScreen - Main dashboard with search, action grid, and floating nav
///
/// React equivalent: HomeScreen component with CustomScrollView
/// - Search bar with voice button
/// - Action cards (Convert, Library, Recent)
/// - Floating bottom navigation (Settings + Add FAB)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FileItem> get _filteredFiles {
    final allFiles = ref.watch(filesProvider);
    if (_searchQuery.isEmpty) return allFiles;
    return allFiles
        .where((f) => f.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  int get _unreadCount {
    final notifications = ref.watch(notificationsProvider);
    return notifications.where((n) => n.unread).length;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final files = _filteredFiles;

    return Container(
      color: isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackgroundLight,
      child: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Top App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeaderIconButton(
                          icon: const Icon(LucideIcons.helpCircle),
                          onTap: () => context.navigateTo(AppScreen.help),
                        ),
                        HeaderIconButton(
                          icon: const Icon(LucideIcons.bell),
                          badgeCount: _unreadCount > 0 ? _unreadCount : null,
                          onTap: () => context.navigateTo(AppScreen.notifications),
                        ),
                      ],
                    ),
                  ),
                ),
                // Greeting
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi Alex,',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            height: 1.0,
                            color: isDark ? AppColors.textSecondaryLight : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'What are we\nlistening to today?',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            height: 1.02,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
                    child: SearchBarWidget(
                      value: _searchQuery,
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                ),
                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _searchQuery.isNotEmpty
                        ? _buildSearchResults(files, isDark)
                        : _buildActionGrid(isDark),
                  ),
                ),
                // Bottom padding for floating nav
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
            // Floating Bottom Navigation
            _buildFloatingNav(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<FileItem> files, bool isDark) {
    if (files.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'No documents found matching "$_searchQuery"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.gray400,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 16),
        ...files.map((file) => _buildFileCard(file, isDark)),
      ],
    );
  }

  Widget _buildFileCard(FileItem file, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: const Icon(
              LucideIcons.fileText,
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
                  file.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${file.size} • ${file.duration}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AnimatedScaleButton(
            onTap: () => context.navigateTo(AppScreen.player),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                LucideIcons.play,
                size: 18,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(bool isDark) {
    return Column(
      children: [
        // Convert card (full width, centered)
        ActionCard(
          title: 'Convert',
          subtitle: 'PDF, DOCX, Images...',
          icon: const Icon(LucideIcons.upload),
          onClick: () => context.navigateTo(AppScreen.upload),
          centered: true,
          delay: 100.ms,
        ),
        const SizedBox(height: 16),
        // Library and Recent (2 columns)
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Library',
                subtitle: 'Your saved audio',
                icon: const Icon(LucideIcons.library),
                onClick: () => context.navigateTo(AppScreen.library),
                delay: 200.ms,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Recent',
                subtitle: 'Continue listening',
                icon: const Icon(LucideIcons.clock),
                onClick: () => context.navigateTo(AppScreen.player),
                delay: 300.ms,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingNav(bool isDark) {
    return Positioned(
      bottom: 36,
      left: 24,
      right: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings/Profile button
          AnimatedScaleButton(
            onTap: () => context.navigateTo(AppScreen.settings),
            child: Container(
              width: 114,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      LucideIcons.settings,
                      size: 28,
                                            color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Icon(
                        LucideIcons.user,
                        size: 24,
                                                color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add FAB
          AnimatedScaleButton(
            onTap: () => context.navigateTo(AppScreen.upload),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? Colors.white : const Color(0xFF1C1C1E)).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.plus,
                size: 32,
                                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
