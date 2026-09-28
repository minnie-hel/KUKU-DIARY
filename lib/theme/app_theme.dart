import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - Lush Poultry Farm Theme
  static const Color primaryGreen = Color(0xFF1B4D3E); // Deep Forest Emerald
  static const Color accentGreen = Color(0xFF2E7D32);  // Farm Green
  static const Color lightGreen = Color(0xFFE8F5E9);   // Mint Accent
  static const Color amberGold = Color(0xFFF59E0B);    // Yolk Gold / Egg Amber
  static const Color warmBg = Color(0xFFF8FAFC);       // Soft Clean Slate
  static const Color darkBg = Color(0xFF0F172A);       // Dark Mode Slate
  static const Color darkCard = Color(0xFF1E293B);     // Dark Mode Card
  static const Color errorRed = Color(0xFFDC2626);     // Alert Red
  static const Color infoBlue = Color(0xFF2563EB);     // Info Blue
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  // Light Theme with Large, Accessible Fonts
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: warmBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: amberGold,
        surface: Colors.white,
        error: errorRed,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 17, color: Colors.black87, height: 1.4),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 15, color: Colors.grey.shade800, height: 1.4),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 13, color: Colors.grey.shade700),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGreen, width: 2.5),
        ),
      ),
    );
  }

  // Dark Theme with Large Fonts
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
        primary: primaryGreen,
        secondary: amberGold,
        surface: darkCard,
        error: errorRed,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amberAccent),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 17, color: Colors.white, height: 1.4),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 15, color: Colors.grey.shade300, height: 1.4),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 13, color: Colors.grey.shade400),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70),
        hintStyle: const TextStyle(fontSize: 15, color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: amberGold, width: 2.5),
        ),
      ),
    );
  }
}
