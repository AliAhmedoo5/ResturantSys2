import 'package:flutter/material.dart';

abstract final class CartelColors {
  static const black = Color(0xFF090A09);
  static const panel = Color(0xFF141614);
  static const raised = Color(0xFF1D201C);
  static const line = Color(0xFF373B33);
  static const yellow = Color(0xFFFFE500);
  static const white = Color(0xFFF5F5EB);
  static const muted = Color(0xFFB6BBAE);
}

ThemeData cartelTheme() {
  const scheme = ColorScheme.dark(
    primary: CartelColors.yellow,
    onPrimary: CartelColors.black,
    secondary: CartelColors.yellow,
    onSecondary: CartelColors.black,
    surface: CartelColors.panel,
    onSurface: CartelColors.white,
    onSurfaceVariant: CartelColors.muted,
    outline: CartelColors.line,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: CartelColors.black,
    fontFamily: 'Segoe UI',
    visualDensity: VisualDensity.standard,
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineLarge: const TextStyle(
        fontSize: 40,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.4,
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      bodyLarge: const TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: const TextStyle(fontSize: 14, height: 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CartelColors.white,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: CartelColors.line),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: CartelColors.line,
      thickness: 1,
      space: 1,
    ),
    tooltipTheme: const TooltipThemeData(
      waitDuration: Duration(milliseconds: 400),
    ),
  );
}
