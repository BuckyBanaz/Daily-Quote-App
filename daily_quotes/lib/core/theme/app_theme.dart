import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';

class AppTheme {
  static ThemeData getTheme({bool isDark = false, Color? primaryColor}) {
    final Color primary = primaryColor ?? AppColors.primary;
    final Color scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF8FBFB);
    final Color surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : AppColors.textPrimary;
    final Color secondaryTextColor = isDark ? Colors.white70 : AppColors.textSecondary;

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        surface: surface,
        onSurface: textColor,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: GoogleFonts.outfit(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.roboto(
          fontSize: 24, 
          fontWeight: FontWeight.bold, 
          color: textColor
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 18, 
          fontWeight: FontWeight.w600, 
          color: textColor
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: secondaryTextColor,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: primary,
          letterSpacing: 1.2,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
        prefixIconColor: primary,
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: isDark ? Colors.white70 : AppColors.iconDefault,
        size: 24,
      ),
      dividerColor: isDark ? Colors.white10 : Colors.grey.shade100,
      hintColor: isDark ? Colors.white38 : Colors.grey.shade600,
    );
  }

  static ThemeData get lightTheme => getTheme(isDark: false);
  static ThemeData get darkTheme => getTheme(isDark: true);
}
