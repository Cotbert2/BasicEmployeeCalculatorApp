import 'package:flutter/material.dart';
import 'color_schema.dart';

class ForegroundTheme {
  static BoxDecoration degradientPrimary = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ColorSchema.primaryColor.withOpacity(0.8),
        ColorSchema.primaryColor,
      ],
    ),
  );
}