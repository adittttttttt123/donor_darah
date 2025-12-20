import 'package:flutter/material.dart';

class AppTheme {
  // Define primary colors
  static const Color primaryColor = Color(0xFFD32F2F); // Red 700
  static const Color secondaryColor = Color(0xFFFFCDD2); // Red 100
  static const Color backgroundColor = Color(0xFFFAFAFA); // Almost White
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFB00020);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Poppins', // Ensure this matches what is in pubspec.yaml
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
        margin: EdgeInsets.zero, // We'll control margin in layout
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // DataTable Theme
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(secondaryColor),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B0000), // Dark Red
        ),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            // ignore: deprecated_member_use
            return secondaryColor.withOpacity(0.5);
          }
          return null; // Use default
        }),
      ),
    );
  }
}
