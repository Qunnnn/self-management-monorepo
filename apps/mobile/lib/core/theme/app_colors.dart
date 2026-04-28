import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color blue = Color(0xFF0075DE);
  static const Color activeBlue = Color(0xFF005BAB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearBlack = Color(0xF2000000); // rgba(0,0,0,0.95)

  // Warm Neutral Scale
  static const Color warmWhite = Color(0xFFF6F5F4);
  static const Color warmDark = Color(0xFF31302E);
  static const Color warmGray600 = Color(0xFF4A4642);
  static const Color warmGray500 = Color(0xFF615D59);
  static const Color warmGray300 = Color(0xFFA39E98);

  // Semantic Accents
  static const Color teal = Color(0xFF2A9D99);
  static const Color green = Color(0xFF1AAE39);
  static const Color orange = Color(0xFFDD5B00);
  static const Color pink = Color(0xFFFF64C8);
  static const Color purple = Color(0xFF391C57);
  static const Color brown = Color(0xFF523410);

  // Interactive
  static const Color linkBlue = Color(0xFF0075DE);
  static const Color linkLightBlue = Color(0xFF62AEF0);
  static const Color focusBlue = Color(0xFF097FE8);
  static const Color badgeBlueBg = Color(0xFFF2F9FF);
  static const Color badgeBlueText = Color(0xFF097FE8);

  // Borders & Dividers
  static const Color whisperBorder = Color(0x1A000000); // rgba(0,0,0,0.1)
  static const Color whisperBorderDark = Color(
    0x1AFFFFFF,
  ); // rgba(255,255,255,0.1)
  static const Color inputBorder = Color(0xFFDDDDDD);
  static const Color inputBorderDark = Color(0xFF4A4A4A);

  // Dark Mode Specific
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color darkBackground = Color(0xFF191919);
  static const Color darkText = Color(0xFFF6F5F4); // Warm White
}
