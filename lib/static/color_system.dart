import 'package:flutter/material.dart';

class ColorSystem {
  static const Color brandColor = Color(0xFF25C0B3);

  static const Color black = Colors.black;

  /// The gray primary color and swatch for EDS.
  ///
  /// ![](https://raw.githubusercontent.com/yeduk3/meali/refs/heads/dev/lib/static/colorpreview/Gray.png)
  static const MaterialColor gray = MaterialColor(_grayPrimaryValue, <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFE9E9E9),
    300: Color(0xFFDBDBDB),
    400: Color(0xFFBABABA),
    500: Color(_grayPrimaryValue),
    600: Color(0xFF737373),
    700: Color(0xFF545454),
    800: Color(0xFF3E3E3E),
    900: Color(0xFF1A1E22),
  });
  static const int _grayPrimaryValue = 0xFF8E8E8E;

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
