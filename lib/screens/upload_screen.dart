import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../providers/theme_provider.dart';
import '../providers/app_providers.dart';
import '../router/app_router.dart';
import '../models/file_item.dart';
import '../widgets/animated_scale_button.dart';

/// UploadScreen - File upload with dashed border drop zone
///
/// React equivalent: UploadScreen with file picker
/// - Dashed border container for drag/drop
/// - File picker integration
/// - Recent files display
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  bool _isUploading = false;

  Future<void> _pickFile() async {
    try {
      setState(() => _isUploading = true);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        // Navigate to processing screen
        ref.context.navigateTo(AppScreen.processing);
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final files = ref.watch(filesProvider);
    final recentFile = files.isNotEmpty ? files.first : null;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldBackgroundDark : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isDark),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Upload Zone
                    _buildUploadZone(isDark),
                    const SizedBox(height: 40),
                    // Recent Files
                    if (recentFile != null) _buildRecentFiles(recentFile, isDark),
                  ],
                ),
              ),
            ),
          ],
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
            'PDF Listener',
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

  Widget _buildUploadZone(bool isDark) {
    return GestureDetector(
      onTap: _pickFile,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(40),
        color: isDark ? const Color(0xFF666666) : const Color(0xFFCCCCCC),
        strokeWidth: 2,
        dashPattern: const [8, 4],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 80),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : const Color(0xFFF2F2F7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.upload,
                  size: 36,
                                    color: AppColors.primaryBlue,
                ),
              )
                  .animate()
                  .scale(
                    duration: const Duration(milliseconds: 200),
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                  )
                  .then()
                  .scale(
                    duration: const Duration(milliseconds: 200),
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(height: 24),
              Text(
                'Upload your PDF',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap to browse or drag file',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentFiles(FileItem file, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'RECENT LISTENS',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.gray400,
            ),
          ),
        ),
        Container(
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
                  color: isDark ? Colors.black : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(14),
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
                      '${file.duration} • ${file.date}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
