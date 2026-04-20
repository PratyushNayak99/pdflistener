import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../models/file_item.dart';
import '../widgets/animated_scale_button.dart';

/// LibraryScreen - List of saved audio files
///
/// React equivalent: LibraryScreen with Dismissible items
/// - AnimatedList for enter/exit animations
/// - Swipe to delete
/// - Play button for each item
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final files = ref.watch(filesProvider);

    return Container(
      color: isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackgroundLight,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(isDark, ref),
            ),
            // File List
            files.isEmpty
                ? SliverToBoxAdapter(
                    child: _buildEmptyState(),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final file = files[index];
                          return _buildFileCard(file, isDark, ref, index);
                        },
                        childCount: files.length,
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
            'Library',
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

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Text(
        'Your library is empty.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.gray400,
        ),
      ),
    );
  }

  Widget _buildFileCard(FileItem file, bool isDark, WidgetRef ref, int index) {
    return Dismissible(
      key: Key(file.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          LucideIcons.trash,
          color: Colors.white,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog(
          context: ref.context,
          builder: (context) => AlertDialog(
            title: const Text('Delete File?'),
            content: Text('Delete "${file.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF3B30)),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(filesProvider.notifier).deleteFile(file.id);
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('${file.title} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.read(filesProvider.notifier).addFile(file);
              },
            ),
          ),
        );
      },
      child: Container(
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
          children: [
            // File Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Icon(
                LucideIcons.fileText,
                size: 24,
                
                color: isDark ? AppColors.primaryBlue : const Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(width: 16),
            // File Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.title,
                    style: TextStyle(
                      fontSize: 16,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Delete button (visible)
            AnimatedScaleButton(
              onTap: () {
                ref.read(filesProvider.notifier).deleteFile(file.id);
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  LucideIcons.trash,
                  size: 20,
                  
                  color: AppColors.gray400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Play button
            AnimatedScaleButton(
              onTap: () => context.navigateTo(AppScreen.player),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  LucideIcons.play,
                  size: 22,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50))
          .slideX(begin: 0.1, end: 0, duration: 400.ms, delay: Duration(milliseconds: index * 50)),
    );
  }
}
