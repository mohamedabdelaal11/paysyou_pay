import 'package:flutter/material.dart';

/// Brand colors and dimensions for built-in PaysYou Pay widgets.
abstract final class PaysYouPayTheme {
  static const primary = Color(0xFF45B5DB);
  static const secondary = Color(0xFF4666A3);
  static const darkPrimary = Color(0xFF0E1726);
  static const darkSecondary = Color(0xFF274C84);
  static const logoAssetPath = 'assets/images/paysyou_logo.png';

  static const buttonHeight = 60.0;
  static const borderRadius = 24.0;

  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkGradient = LinearGradient(
    colors: [darkPrimary, darkSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient gradientFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkGradient : primaryGradient;
  }

  static Color foregroundColorFor(Brightness brightness) {
    return Colors.white;
  }

  static Color outlinedSurfaceColorFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF0B1220)
        : const Color(0xFFF7FAFC);
  }
}
