import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/authentication/screens/login_screen.dart';
import 'package:gosheep_mobile/features/breeding_history/screens/breeding_history_screen.dart';
import 'package:gosheep_mobile/features/cage/screens/cage_screen.dart';
import 'package:gosheep_mobile/features/main_navigation.dart';
import 'package:gosheep_mobile/features/livestock_history/screens/livestock_history_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String cage = '/cage';
  static const String breedingHistory = '/breeding-history';
  static const String livestockHistory = '/livestock-history';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    home: (context) => MainNavigation(),
    cage: (context) => CageScreen(),
    breedingHistory: (context) => BreedingHistoryScreen(),
    livestockHistory: (context) => LivestockHistoryScreen(),
  };
}
