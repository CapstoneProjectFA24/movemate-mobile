import 'package:flutter/material.dart';
import '../../utils/constants/asset_constant.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AssetsConstants.scaffoldColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AssetsConstants.whiteColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AssetsConstants.mainColor,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AssetsConstants.mainColor,
    ),
  );
}
