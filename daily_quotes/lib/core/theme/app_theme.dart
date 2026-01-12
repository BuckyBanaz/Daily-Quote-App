import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      // Text Theme
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.roboto(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textPrimary
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 18, 
          fontWeight: FontWeight.w600, 
          color: AppColors.textPrimary
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.accentText,
          letterSpacing: 1.2,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.iconDefault,
        size: 24,
      ),
    );
  }
}
