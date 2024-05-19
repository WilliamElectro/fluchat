import 'package:flutter/material.dart';

const primaryColor = Color(0xFF3883FB);
const backgroundLightColor = Color(0xFFFCFCFC);
const backgroundDarkColor = Color(0xFF1F2026);
const navigationBarLightColor = Colors.white70;
const navigationBarDarkColor = Color(0xFF30313C);

class Themes {
  static final themeLight = ThemeData.light().copyWith(
    colorScheme: ColorScheme.light().copyWith(
      background: backgroundLightColor,
      // selected color
      primary: primaryColor,
    ),
    // floating action button icono de los botones
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white70,
    ),
    // bottom bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: navigationBarLightColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[500],
    ),
    // switch active color
    toggleableActiveColor: primaryColor,
    canvasColor: backgroundLightColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Color gris cuando está deshabilitado
          }
          return primaryColor; // Color primario cuando está habilitado
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Color gris para el texto cuando está deshabilitado
          }
          return Colors.white; // Color blanco para el texto cuando está habilitado
        }),
      ),
    ),
  );

  static final themeDark = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark().copyWith(
      background: backgroundDarkColor,
      // selected color
      primary: primaryColor,
    ),
    // floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    // bottom bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: navigationBarDarkColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[300],
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.white,
    ),
    canvasColor: backgroundDarkColor,
    appBarTheme: AppBarTheme(
      color: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Color gris cuando está deshabilitado
          }
          return primaryColor; // Color primario cuando está habilitado
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // Color gris para el texto cuando está deshabilitado
          }
          return Colors.white; // Color blanco para el texto cuando está habilitado
        }),
      ),
    ),
  );
}
