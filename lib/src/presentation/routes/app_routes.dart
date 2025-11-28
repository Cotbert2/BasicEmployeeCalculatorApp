import 'package:flutter/material.dart';
import './../views/home_page.dart';
import './../views/result_page.dart';
import './../views/history_page.dart';
import './../../domain/entities/result_employee.dart';

class AppRoutes {
  static const String home = '/';
  static const String result = '/result';
  static const String history = '/history';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    result: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as ResultEmployee?;
      return ResultPage(resultEmployee: args);
    },
    history: (context) => const HistoryPage(),
  };
}