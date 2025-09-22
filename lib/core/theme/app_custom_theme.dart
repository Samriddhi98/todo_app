import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData baseTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      // primaryColor: context.watch<AppThemeCubit>().state.primaryColor,
      // scaffoldBackgroundColor: context
      //     .watch<AppThemeCubit>()
      //     .state
      //     .primaryColor,
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        labelSmall: TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
      ),
    );
    return baseTheme.copyWith();
  }
}
