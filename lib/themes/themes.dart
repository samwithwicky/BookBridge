import 'package:flutter/material.dart';

class BookBridgeLogo extends StatelessWidget {
  final double size;

  const BookBridgeLogo({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/bookbridge.jpg', // Make sure to add the logo to your assets
      width: size,
      height: size * 0.6, // Maintain aspect ratio
    );
  }
}

ThemeData bookBridgeTheme() {
  // Define our color scheme
  const primaryColor = Colors.white;
  const accentColor = Colors.deepOrange;
  const highlightColor = Colors.deepOrangeAccent;

  return ThemeData(
    // Basic colors
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: accentColor,
      secondary: highlightColor,
      onPrimary: Colors.white,
      surface: Colors.white,
    ),

    // Text themes
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
        color: accentColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: accentColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: accentColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      prefixIconColor: accentColor,
      suffixIconColor: accentColor,
      labelStyle: const TextStyle(color: Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accentColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),

    // Chip theme for the metadata chips
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.white,
      disabledColor: Colors.grey,
      selectedColor: accentColor,
      secondarySelectedColor: highlightColor,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(color: Colors.black87),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      brightness: Brightness.light,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Card theme
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
  );
}
