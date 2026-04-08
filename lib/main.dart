import 'package:flutter/material.dart';
import 'package:gosheep_mobile/routes/app_routes.dart';
import 'core/theme/theme.dart';
import 'features/authentication/screens/login_screen.dart';

void main() {
  runApp(const GoSheepApp());
}

class GoSheepApp extends StatelessWidget {
  const GoSheepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoSheep',
      home: LoginScreen(),
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
