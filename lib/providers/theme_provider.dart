import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme Provider - Manages light/dark mode state
/// Replaces React's isDarkMode state and context passing

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', !isDark);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// Color Palette - Exact translation from React/Tailwind
class AppColors {
  // Light Mode
  static const scaffoldBackgroundLight = Color(0xFFF2F2F7);
  static const cardBackgroundLight = Colors.white;
  static const primaryBlue = Color(0xFF5B8DEF);
  static const textPrimaryLight = Color(0xFF1C1C1E);
  static const textSecondaryLight = Color(0xFF9CA3AF);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray100 = Color(0xFFF2F2F7);
  static const gray50 = Color(0xFFF8F9FB);
  static const gray200 = Color(0xFFE5E7EB);

  // Dark Mode
  static const scaffoldBackgroundDark = Colors.black;
  static const cardBackgroundDark = Color(0xFF1C1C1E);
  static const textPrimaryDark = Colors.white;
  static const gray800 = Color(0xFF1C1C1E);
  static const gray700 = Color(0xFF333333);

  // Accent Colors
  static const orangeAccent = Color(0xFFFF6B00);
  static const redDanger = Color(0xFFFF3B30);
  static const greenSuccess = Color(0xFF34C759);

  // Shadows
  static const shadowLight = Color(0x0D000000); // black.withOpacity(0.05)
  static const shadowMedium = Color(0x1A000000);
  static const shadowHeavy = Color(0x33000000);
}

/// Typography - Inter font with SF Pro-like metrics
class AppTextStyles {
  static TextStyle get base => GoogleFonts.inter();

  // Giant Quirky Typography (Login screen)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.0,
    height: 0.95,
  );

  // Greeting text (40px bold)
  static const TextStyle greeting = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.0,
  );

  // Headline (26px)
  static const TextStyle headline = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
  );

  // Title (22px)
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.2,
  );

  // Body (17px)
  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  // Caption (15px)
  static const TextStyle caption = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  // Small (13px)
  static const TextStyle small = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // Tiny (12px)
  static const TextStyle tiny = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}

/// Theme Data - Light and Dark
ThemeData lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
  primaryColor: AppColors.primaryBlue,
  cardColor: AppColors.cardBackgroundLight,
  canvasColor: AppColors.gray50,
  textTheme: GoogleFonts.interTextTheme().copyWith(
    displayLarge: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      letterSpacing: -1.0,
      height: 0.95,
      color: AppColors.textPrimaryLight,
    ),
    headlineLarge: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.3,
      color: AppColors.textPrimaryLight,
    ),
    titleMedium: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.2,
      color: AppColors.textPrimaryLight,
    ),
    bodyLarge: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),
    bodyMedium: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textPrimaryLight,
    size: 24,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
  primaryColor: AppColors.primaryBlue,
  cardColor: AppColors.cardBackgroundDark,
  canvasColor: AppColors.gray800,
  textTheme: GoogleFonts.interTextTheme().copyWith(
    displayLarge: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      letterSpacing: -1.0,
      height: 0.95,
      color: AppColors.textPrimaryDark,
    ),
    headlineLarge: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.3,
      color: AppColors.textPrimaryDark,
    ),
    titleMedium: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.2,
      color: AppColors.textPrimaryDark,
    ),
    bodyLarge: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textPrimaryDark,
    size: 24,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
  ),
);
