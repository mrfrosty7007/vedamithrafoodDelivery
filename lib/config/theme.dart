import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Brand Colors
// 🌿 Green Brand Colors
static const Color primaryColor = Color(0xFF2E7D32); // Deep green
static const Color primaryDark = Color(0xFF1B5E20);
static const Color accentColor = Color(0xFF66BB6A); // Soft green
static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE63946);
  static const Color successColor = Color(0xFF2D6A4F);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color dividerColor = Color(0xFFDFE6E9);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
colorScheme: ColorScheme.fromSeed(
  seedColor: primaryColor,
  brightness: Brightness.light,
),
dividerTheme: const DividerThemeData(
  color: dividerColor,
  thickness: 1,
),

textTheme: const TextTheme(
  titleLarge: TextStyle(
    fontWeight: FontWeight.bold,
  ),
  bodyMedium: TextStyle(
    color: textPrimary,
  ),
),

navigationBarTheme: NavigationBarThemeData(
  backgroundColor: Colors.white,
  indicatorColor: primaryColor.withOpacity(0.15),
  labelTextStyle: WidgetStateProperty.all(
    const TextStyle(fontWeight: FontWeight.w600),
  ),
),

      scaffoldBackgroundColor: backgroundColor,
appBarTheme: const AppBarTheme(
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  elevation: 0,
  centerTitle: false,
),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
    ),
  ),
),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
      cardTheme: CardThemeData(
elevation: 4,
surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
  backgroundColor: primaryDark,
  contentTextStyle: const TextStyle(color: Colors.white),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
  behavior: SnackBarBehavior.floating,
),

    );
  }
}
