import 'package:flutter/material.dart';

class AppThemeDatas {
  static final ThemeData lightTheme =  ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF039D55),
  secondaryHeaderColor: const Color(0xFF1ED7AA),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(primary: Color(0xFF039D55), secondary: Color(0xFF039D55)),
);

  static final ThemeData darkTheme = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF54b46b),
  secondaryHeaderColor: const Color(0xFF009f67),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: const ColorScheme.dark(primary: Color(0xFF54b46b), secondary: Color(0xFF54b46b)),
);
}
