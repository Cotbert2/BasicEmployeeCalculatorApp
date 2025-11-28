import 'package:flutter/material.dart';
import './color_schema.dart';

class AppBarOwnTheme {
  static  AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: ColorSchema.primaryColor,
    foregroundColor: ColorSchema.onPrimaryColor,
    elevation: 3,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: ColorSchema.onPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

}