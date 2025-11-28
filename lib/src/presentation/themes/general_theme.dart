import 'package:flutter/material.dart';
import 'color_schema.dart';
import './app_bar_own_theme.dart';
import './button_theme_own.dart';
import './form_theme.dart';
import './typography_theme.dart';

class GeneralTheme {
  static  ThemeData generalThemeLight = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: ColorSchema.primaryColor,
      onPrimary: ColorSchema.onPrimaryColor,
      secondary: ColorSchema.secondaryColor,
      onSecondary: ColorSchema.onSecondaryColor,
      background: ColorSchema.backgroundColor,
      onBackground: ColorSchema.onBackgroundColor,
      surface: ColorSchema.surfaceColor,
      onSurface: ColorSchema.onSurfaceColor,
    ),
    appBarTheme: AppBarOwnTheme.appBarTheme,
    elevatedButtonTheme: ButtonThemeOwn.primaryButton,
    // outlinedButtonTheme: ButtonThemeOwn.secondaryButton,
    inputDecorationTheme: FormTheme.textFieldTemplate,
    textTheme: TypographyTheme.textTheme,
    scaffoldBackgroundColor: ColorSchema.backgroundColor


  );
}