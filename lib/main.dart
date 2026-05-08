import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/navigator_key.dart';
import 'package:gosheep_mobile/data/providers/user_provider.dart';
import 'package:gosheep_mobile/routes/app_routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  runApp(const GoSheepApp());
}

class GoSheepApp extends StatelessWidget {
  const GoSheepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],

      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'GoSheep',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
