import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(253, 248, 242, 1),
    primaryColor: Colors.blue,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.cyan,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.cyan,
    colorScheme: const ColorScheme.dark(
      primary: Colors.cyan,
      secondary: Colors.blue,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white24,
  );
}