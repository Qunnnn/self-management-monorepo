import 'package:flutter/material.dart';

class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.cardShadow,
    required this.deepShadow,
  });

  final List<BoxShadow> cardShadow;
  final List<BoxShadow> deepShadow;

  @override
  AppShadows copyWith({
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? deepShadow,
  }) {
    return AppShadows(
      cardShadow: cardShadow ?? this.cardShadow,
      deepShadow: deepShadow ?? this.deepShadow,
    );
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return AppShadows(
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
      deepShadow: BoxShadow.lerpList(deepShadow, other.deepShadow, t)!,
    );
  }

  static AppShadows get light => AppShadows(
        cardShadow: [
          const BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            offset: Offset(0, 4),
            blurRadius: 18,
          ),
          const BoxShadow(
            color: Color(0x07000000), // rgba(0,0,0,0.027)
            offset: Offset(0, 2.025),
            blurRadius: 7.84688,
          ),
          const BoxShadow(
            color: Color(0x05000000), // rgba(0,0,0,0.02)
            offset: Offset(0, 0.8),
            blurRadius: 2.925,
          ),
          const BoxShadow(
            color: Color(0x03000000), // rgba(0,0,0,0.01)
            offset: Offset(0, 0.175),
            blurRadius: 1.04062,
          ),
        ],
        deepShadow: [
          const BoxShadow(
            color: Color(0x03000000), // rgba(0,0,0,0.01)
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
          const BoxShadow(
            color: Color(0x05000000), // rgba(0,0,0,0.02)
            offset: Offset(0, 3),
            blurRadius: 7,
          ),
          const BoxShadow(
            color: Color(0x05000000), // rgba(0,0,0,0.02)
            offset: Offset(0, 7),
            blurRadius: 15,
          ),
          const BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            offset: Offset(0, 14),
            blurRadius: 28,
          ),
          const BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 23),
            blurRadius: 52,
          ),
        ],
      );

  // Dark mode shadows use a slightly higher opacity or different base color to be visible on dark surfaces
  static AppShadows get dark => AppShadows(
        cardShadow: [
          const BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 4),
            blurRadius: 18,
          ),
          const BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 2.025),
            blurRadius: 7.84688,
          ),
        ],
        deepShadow: [
          const BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 23),
            blurRadius: 52,
          ),
        ],
      );
}
