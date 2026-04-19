import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'animated_scale_button.dart';
import '../providers/theme_provider.dart';

/// SearchBarWidget - Global search with voice button
///
/// React equivalent: Search bar Container with TextField and Mic button
/// - BorderRadius: 28
/// - Height: 64
/// - Focus ring on focus
class SearchBarWidget extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback? onVoiceTap;
  final String placeholder;

  const SearchBarWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.onVoiceTap,
    this.placeholder = 'Search documents...',
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(28),
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
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            LucideIcons.search,
            size: 22,
            color: AppColors.gray400,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray400,
                ),
              ),
              cursorColor: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          if (widget.value.isNotEmpty)
            AnimatedScaleButton(
              onTap: () => widget.onChanged(''),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '×',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.gray400,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          AnimatedScaleButton(
            onTap: widget.onVoiceTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF333333)
                    : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                LucideIcons.mic,
                size: 20,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
