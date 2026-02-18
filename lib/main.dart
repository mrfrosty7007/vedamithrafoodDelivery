import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'presentation/auth/providers/auth_provider.dart';
import 'presentation/customer/providers/cart_provider.dart';
import 'data/services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(FirebaseAuthService()),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const FoodDeliveryApp(),
    ),
  );
}
