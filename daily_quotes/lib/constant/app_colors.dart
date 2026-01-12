import 'package:flutter/material.dart';

class AppColors {
  // Main Colors
  static const Color primary = Color(0xFF26A69A); // Teal/Cyan from the design
  static const Color secondary = Color(0xFFE0F2F1);
  
  // Backgrounds
  static const Color background = Color(0xFFF5F5F5); // Light Gray
  static const Color surface = Colors.white;
  
  // Text
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color accentText = Color(0xFF26A69A); // For Author Name
  
  // Icons
  static const Color iconDefault = Color(0xFF757575);
  static const Color iconActive = Color(0xFF26A69A);
  static const Color iconLove = Color(0xFFE57373); // Red/Pink for favorite heart

  // Shadows
  static const BoxShadow defaultShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );
}
