import 'package:flutter/material.dart';
import 'package:meali/static/color_system.dart';

class FontSystem {
  static const TextStyle appNameTitle = TextStyle(
    color: ColorSystem.brandColor,
    fontSize: 32,
    fontFamily: 'PartialSans',
  );

  static const TextStyle inputStyle = TextStyle(
    color: Color(0xFFB3B3B3),
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kakaoInput = TextStyle(
    color: Color(0xFF191F28),
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle title = TextStyle(
    color: ColorSystem.gray01,
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
    letterSpacing: -0.16,
  );

  static const TextStyle memoTitle = TextStyle(
    color: Color(0xFF191F28),
    fontSize: 16,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
  );

  static const TextStyle count = TextStyle(
    color: ColorSystem.gray03,
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.42,
  );

  static const TextStyle name14 = TextStyle(
    color: ColorSystem.gray01,
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    letterSpacing: -0.42,
  );

  static const TextStyle nameother12 = TextStyle(
    color: ColorSystem.gray04,
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.30,
  );

  static const TextStyle nameme12 = TextStyle(
    color: ColorSystem.gray03,
    fontSize: 12,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
    letterSpacing: -0.30,
  );

  static const TextStyle content14 = TextStyle(
    color: ColorSystem.gray01,
    fontSize: 14,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    letterSpacing: -0.28,
  );
}
