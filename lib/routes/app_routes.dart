import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/authentication/screens/login_screen.dart';
import 'package:gosheep_mobile/features/main_navigation.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    home: (context) => MainNavigation(),
  };
}