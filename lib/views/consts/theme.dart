import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final data = ThemeData(
    primaryColor: const Color(0xFFe7c496),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFFe7c496),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: const Color(0xFFe7c496),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
