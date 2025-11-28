import 'package:flutter/material.dart';
import 'color_schema.dart';

class FormTheme {
  static final textFieldTemplate = InputDecorationTheme(
    filled: true,
    fillColor: ColorSchema.surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    hintStyle: TextStyle(
      color: ColorSchema.onSurfaceColor.withOpacity(0.6),
      fontSize: 16,
    ),
    focusColor: ColorSchema.primaryColor,
  );
}