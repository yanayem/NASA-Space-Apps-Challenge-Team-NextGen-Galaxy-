import 'package:flutter/material.dart';

class AppTheme {
  // Brand accent colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF2563EB);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentRed = Color(0xFFEF4444);

  // Dark Theme Palette
  static const Color darkScaffold = Color(0xFF0B0E14);
  static const Color darkCard = Color(0xFF151921);
  static const Color darkSubCard = Color(0xFF0E121A);
  static const Color darkBorder = Color(0xFF222938);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Light Theme Palette
  static const Color lightScaffold = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSubCard = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkScaffold,
      cardColor: darkCard,
      canvasColor: darkCard,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentPurple,
        surface: darkCard,
        surfaceContainerHighest: darkSubCard,
        outline: darkBorder,
        outlineVariant: Color(0xFF1E293B),
        onSurface: darkTextPrimary,
        onSurfaceVariant: darkTextSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerColor: darkBorder,
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryBlue;
          return Colors.white54;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue.withValues(alpha: 0.35);
          }
          return Colors.white12;
        }),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightScaffold,
      cardColor: lightCard,
      canvasColor: lightCard,
      colorScheme: const ColorScheme.light(
        primary: primaryBlueDark,
        secondary: accentPurple,
        surface: lightCard,
        surfaceContainerHighest: lightSubCard,
        outline: lightBorder,
        outlineVariant: Color(0xFFCBD5E1),
        onSurface: lightTextPrimary,
        onSurfaceVariant: lightTextSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightCard,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightCard,
        selectedItemColor: primaryBlueDark,
        unselectedItemColor: Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerColor: lightBorder,
      dialogTheme: DialogThemeData(
        backgroundColor: lightCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryBlueDark;
          return const Color(0xFF94A3B8);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlueDark.withValues(alpha: 0.25);
          }
          return const Color(0xFFE2E8F0);
        }),
      ),
    );
  }
}

extension AppThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get cardBg => isDarkMode ? AppTheme.darkCard : AppTheme.lightCard;
  Color get subCardBg => isDarkMode ? AppTheme.darkSubCard : AppTheme.lightSubCard;
  Color get cardBorder => isDarkMode ? AppTheme.darkBorder : AppTheme.lightBorder;
  Color get textPrimary => isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondary => isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get textMuted => isDarkMode ? AppTheme.darkTextMuted : AppTheme.lightTextMuted;
  Color get inputBg => isDarkMode ? AppTheme.darkSubCard : const Color(0xFFF8FAFC);
  Color get dropdownBg => isDarkMode ? AppTheme.darkCard : AppTheme.lightCard;

  // Box decorations for consistent elevation and styling
  BoxDecoration get cardDecoration => BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      );

  BoxDecoration get subCardDecoration => BoxDecoration(
        color: subCardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cardBorder),
      );
}
