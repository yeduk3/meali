import 'package:flutter/material.dart';

class ColorSystem {
  static const Color black = Colors.black;

  /// 0xFF191F28
  static const Color gray01 = Color(0xFF191F28);

  /// 0xFF333D4B
  static const Color gray02 = Color(0xFF333D4B);

  /// 0xFF4E5968
  static const Color gray03 = Color(0xFF4E5968);

  /// 0xFF6B7684
  static const Color gray04 = Color(0xFF6B7684);

  /// 0xFF8B95A1
  static const Color gray05 = Color(0xFF8B95A1);

  /// 0xFFB0B8C1
  static const Color gray06 = Color(0xFFB0B8C1);

  /// 0xFFD1D6DB
  static const Color gray07 = Color(0xFFD1D6DB);

  /// 0xFFE5E8EB
  static const Color gray08 = Color(0xFFE5E8EB);

  /// 0xFFF2F4F6
  static const Color gray09 = Color(0xFFF2F4F6);

  /// 0xFFF9FAFB
  static const Color gray10 = Color(0xFFF9FAFB);
  static const Color white = Colors.white;

  static const List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x1E000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      // spreadRadius: 4,
    )
  ];
}
