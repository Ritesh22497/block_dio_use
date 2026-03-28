import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF0A0A0F);
  static const surface = Color(0xFF13131A);
  static const card = Color(0xFF1A1A24);
  static const accent = Color(0xFF00E5FF);
  static const accent2 = Color(0xFF7C3AED);
  static const accent3 = Color(0xFFF59E0B);
  static const textPrimary = Color(0xFFE8E8F0);
  static const textMuted = Color(0xFF6B6B80);
  static const border = Color(0x12FFFFFF);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.surface,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      );
}

class AppTextStyles {
  static TextStyle get mono => GoogleFonts.spaceMono(
        color: AppColors.textPrimary,
        letterSpacing: 0.05,
      );

  static TextStyle get display => GoogleFonts.syne(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        color: AppColors.textPrimary,
      );
}
