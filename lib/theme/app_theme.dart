import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Surface & Canvas
  static const Color background = Color(0xFFFBF9F7); // Warm porcelain linen
  static const Color primaryAccent = Color(0xFFE5583E); // Vibrant Sunset Coral / Terracotta Pop
  static const Color primaryAccentEnd = Color(0xFFF0715B); // Gradient complement for radiant accents
  static const Color textPrimary = Color(0xFF1F1A19); // Rich Obsidian-Espresso
  static const Color textSecondary = Color(0xFF6B5E5B); // Warm Truffle Brown
  static const Color textTertiary = Color(0xFF9E928F); // Soft Muted Taupe

  // Card Status 1: Recomended (Electric Sky / Cerulean Blue)
  static const Color cardBlueBg = Color(0xFFF0F6FF);
  static const Color cardBlueBorder = Color(0xFFBFDBFE);
  static const Color badgeBlueBg = Color(0xFFDBEAFE);
  static const Color badgeBlueText = Color(0xFF1D4ED8);
  static const Color blueDot = Color(0xFF2563EB);

  // Card Status 2: Wishlist (Vibrant Rose / Raspberry Pink)
  static const Color cardPinkBg = Color(0xFFFFF1F4);
  static const Color cardPinkBorder = Color(0xFFFECDD6);
  static const Color badgePinkBg = Color(0xFFFFE4E8);
  static const Color badgePinkText = Color(0xFFBE123C);
  static const Color pinkDot = Color(0xFFF43F5E);

  // Card Status 3: Tidak Rekomendasi (Warm Vivid Amber / Tangerine)
  static const Color cardOrangeBg = Color(0xFFFFF7ED);
  static const Color cardOrangeBorder = Color(0xFFFED7AA);
  static const Color badgeOrangeBg = Color(0xFFFFEDD5);
  static const Color badgeOrangeText = Color(0xFFC2410C);
  static const Color orangeDot = Color(0xFFF97316);

  // Legacy / Acoustic Level indicators
  static const Color cardGreenBg = cardBlueBg;
  static const Color cardGreenBorder = cardBlueBorder;
  static const Color badgeGreenBg = Color(0xFFDCFCE7);
  static const Color badgeGreenText = Color(0xFF15803D);
  static const Color greenDot = Color(0xFF16A34A);

  static const Color cardAmberBg = cardPinkBg;
  static const Color cardAmberBorder = cardPinkBorder;
  static const Color badgeAmberBg = Color(0xFFFEF3C7);
  static const Color badgeAmberText = Color(0xFFB45309);
  static const Color amberDot = Color(0xFFD97706);

  static const Color cardRedBg = cardOrangeBg;
  static const Color cardRedBorder = cardOrangeBorder;
  static const Color badgeRedBg = Color(0xFFFFE4E6);
  static const Color badgeRedText = Color(0xFFBE123C);
  static const Color redDot = Color(0xFFE11D48);

  // Neutral items
  static const Color chipBackground = Color(0xFFFFFFFF);
  static const Color chipBorder = Color(0xFFE6E0DD);
  static const Color cardContentBg = Color(0xFFFFFFFF);
  static const Color darkButton = Color(0xFF1F1A19);
  static const Color darkButtonHover = Color(0xFF2D2624);
}

class AppTypography {
  static TextStyle headlineDisplay({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.newsreader(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: -0.5,
    );
  }

  static TextStyle headlineSerif({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.newsreader(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: -0.3,
    );
  }

  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.4,
  }) {
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle label({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textSecondary,
    double? letterSpacing,
  }) {
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
