import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gradientStart,
      secondary: AppColors.gradientEnd,
    ),
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.gradientStart,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.white70),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gradientStart,
      secondary: AppColors.gradientEnd,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.gradientStart,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.white70),
    ),
  );
}
