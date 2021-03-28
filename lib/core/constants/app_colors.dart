import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor black = const MaterialColor(
      0xFF333333,
      const <int, Color>{
        50: Color(0xFFf7f7f7),
        100: Color(0xFFeeeeee),
        200: Color(0xFFe3e3e3),
        300: Color(0xFFd1d1d1),
        400: Color(0xFFacacac),
        500: Color(0xFF8b8b8b),
        600: Color(0xFF646464),
        700: Color(0xFF515151),
        800: Color(0xFF333333),
        900: Color(0xFF131313)
      }
  );

  static const MaterialColor grey = const MaterialColor(
      0xFF888888,
      const <int, Color>{
        50: Color(0xFFfdfdfd),
        100: Color(0xFFf8f8f8),
        200: Color(0xFFf3f3f3),
        300: Color(0xFFeeeeee),
        400: Color(0xFFd0d0d0),
        500: Color(0xFFb3b3b3),
        600: Color(0xFF888888),
        700: Color(0xFF737373),
        800: Color(0xFF535353),
        900: Color(0xFF303030),
      }
  );
}