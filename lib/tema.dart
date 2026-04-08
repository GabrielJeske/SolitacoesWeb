import 'package:flutter/material.dart';

class AppThemes {
  // --- MODO ESCURO ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:  Color(0xFF080808),
    colorScheme:  ColorScheme.dark(
      primary: Color(0xFFC62828), // Vermelho
      secondary: Color(0xFF1565C0), // Azul
      surface: Color(0xFF1E1E1E), 
      onSurface: Color(0xFFEEEEEE), 
      secondaryContainer: Colors.grey.shade900, // Cor do balão Ímpar
      tertiaryContainer: Colors.blueGrey.shade800,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF080808), // Fundo escuro
      foregroundColor: Colors.white, // Letras e ícones brancos
      centerTitle: true, // Centraliza o título
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    // Padroniza as caixas de texto no Dark Mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      labelStyle: TextStyle(color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC62828), width: 2), // Borda vermelha ao focar
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700, // <-- Agora o padrão do app é Verde!
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1565C0), // Padrão Azul
        side: const BorderSide(color: Color(0xFF1565C0)), 
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  // --- MODO CLARO ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme:  ColorScheme.light(
      primary: Color(0xFFC62828), // Vermelho
      secondary: Color(0xFF1565C0), // Azul
      surface: Colors.white, 
      onSurface: Colors.black87,
      secondaryContainer: Colors.grey.shade200, 
      tertiaryContainer: Colors.blueGrey.shade100
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFC62828), // Speed Red
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    // Padroniza as caixas de texto no Light Mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey.shade700),
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
        borderSide: const BorderSide(color: Color(0xFFC62828), width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700, // <-- Agora o padrão do app é Verde!
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1565C0),
        side: const BorderSide(color: Color(0xFF1565C0)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}