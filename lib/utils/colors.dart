// lib/utils/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary gradient colors (Black to Green theme)
  static const Color primaryBlack = Color(0xFF000000);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF2A2A2A);
  
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color darkGreen = Color(0xFF064E3B);
  static const Color mintGreen = Color(0xFF6EE7B7);
  
  // Accent colors
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentBlue = Color(0xFF3B82F6);
  
  // Text colors
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFB0B0B0);
  static const Color textDark = Color(0xFF6B7280);
  
  // Background colors
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color cardDark = Color(0xFF1F1F1F);
  static const Color cardDarker = Color(0xFF141414);
  
  // Doodle colors
  static const Color doodlePink = Color(0xFFFFB3D9);
  static const Color doodleYellow = Color(0xFFFFD93D);
  static const Color doodlePurple = Color(0xFFC084FC);
  
  // Status colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000),
      Color(0xFF064E3B),
      Color(0xFF10B981),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1F1F1F),
      Color(0xFF2A2A2A),
    ],
  );
  
  static const LinearGradient greenGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF00FF88),
      Color(0xFF10B981),
      Color(0xFF064E3B),
    ],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );
}

// Theme Data
ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.neonGreen,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.neonGreen,
      secondary: AppColors.emeraldGreen,
      surface: AppColors.cardDark,
      background: AppColors.backgroundDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.emeraldGreen,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}