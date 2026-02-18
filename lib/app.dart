import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vedamithra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.roleSelection,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
