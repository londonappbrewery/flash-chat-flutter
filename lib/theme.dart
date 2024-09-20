import 'package:flutter/material.dart';
import './constants.dart';

class AppColors {
  static const secondary = Color(0xFF001A83);
  // static const primary = Color(0xFF002DE3);
  static const primary = Color(0xFF7BCBCF);
  static const accent = Color(0xFFCDE1FD);
  static const textDark = Color(0xFF0F1828);
  static const textLight = Color(0xFFF7F7FC);
  static const textFaded = Color(0xFFADB5BD);
  static const darkPrimary = Color(0xFF7BCBCF);
  static const darkBackground = Color(0xFF0F1828);
  static const darkCardColor = Color(0xFF152033);
  static const cardColor = Color.fromARGB(255, 238, 243, 244);
  static const backgroundColor = Color.fromARGB(255, 251, 251, 251);
  static const errorColor = Color(0xFFE94242);
}

class AppTheme {
  static ThemeData light(ThemeData theme) => ThemeData(
      appBarTheme:
          const AppBarTheme(backgroundColor: AppColors.backgroundColor),
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.textDark,
      disabledColor: AppColors.textFaded,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      cardColor: AppColors.cardColor,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      textTheme: TextTheme(
          titleLarge: kHeadingStyle1(color: AppColors.textDark),
          titleMedium: kHeadingStyle2(color: AppColors.textDark),
          titleSmall: kSubheadingStyle1(color: AppColors.textDark),
          bodyLarge: kBodyStyle1(color: AppColors.textDark),
          bodyMedium: kBodyStyle2(fontSize: 12, color: AppColors.textDark),
          labelLarge: kMetadataStyle1(color: AppColors.textDark),
          labelMedium: kMetadataStyle2(color: AppColors.textDark),
          labelSmall: kMetadataStyle3(color: AppColors.textDark)));
  static ThemeData dark(ThemeData theme) => ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkBackground),
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      primaryColorDark: AppColors.textLight,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCardColor,
      iconTheme: const IconThemeData(color: AppColors.textLight),
      textTheme: TextTheme(
          titleLarge: kHeadingStyle1(color: AppColors.textLight),
          titleMedium: kHeadingStyle2(color: AppColors.textLight),
          titleSmall: kSubheadingStyle1(color: AppColors.textLight),
          bodyLarge: kBodyStyle1(color: AppColors.textLight),
          bodyMedium: kBodyStyle2(fontSize: 12, color: AppColors.textLight),
          labelLarge: kMetadataStyle1(color: AppColors.textLight),
          labelMedium: kMetadataStyle2(color: AppColors.textLight),
          labelSmall: kMetadataStyle3(color: AppColors.textLight)));
}
