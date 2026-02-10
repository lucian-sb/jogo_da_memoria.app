import 'package:flutter/material.dart';

/// Tema infantil com paleta vibrante e estilos amigáveis
class AppTheme {
  // Paleta de cores infantil
  static const Color azulPrincipal = Color(0xFF2EB4F3);
  static const Color azulClaro = Color(0xFF7DDCFF);
  static const Color amarelo = Color(0xFFFFD43B);
  static const Color verde = Color(0xFF4CD964);
  static const Color vermelho = Color(0xFFFF4D4D);
  static const Color roxo = Color(0xFFAF52DE);
  static const Color rosa = Color(0xFFFF6EC7);
  static const Color branco = Color(0xFFFFFFFF);

  // Gradientes de fundo
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [azulClaro, rosa],
  );

  static const LinearGradient backgroundGradientAlt = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [azulPrincipal, roxo],
  );

  // Cores para cartas
  static const Color cartaFechada = azulClaro;
  static const Color cartaAberta = amarelo;
  static const Color cartaEncontrada = verde;

  // Tema global
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: azulPrincipal,
        secondary: roxo,
        tertiary: rosa,
        surface: branco,
        error: vermelho,
        onPrimary: branco,
        onSecondary: branco,
        onSurface: Colors.black87,
        onError: branco,
      ),
      scaffoldBackgroundColor: azulClaro,
      appBarTheme: AppBarTheme(
        backgroundColor: azulPrincipal,
        foregroundColor: branco,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: branco,
        ),
        iconTheme: const IconThemeData(
          color: branco,
          size: 28,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: azulPrincipal,
          foregroundColor: branco,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: azulPrincipal,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: azulPrincipal, width: 3),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: roxo,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: branco,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: azulPrincipal, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: azulPrincipal, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: roxo, width: 3),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 18,
        ),
        labelStyle: const TextStyle(
          color: azulPrincipal,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      cardTheme: CardTheme(
        color: branco,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  // Estilos de texto customizados
  static TextStyle titleStyle({double? fontSize, Color? color}) {
    return TextStyle(
      fontSize: fontSize ?? 36,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black87,
    );
  }

  static TextStyle subtitleStyle({double? fontSize, Color? color}) {
    return TextStyle(
      fontSize: fontSize ?? 24,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.black87,
    );
  }

  static TextStyle bodyStyle({double? fontSize, Color? color}) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.black87,
    );
  }

  // Cores para níveis (rotaciona entre cores vibrantes)
  static Color getLevelColor(int nivel) {
    final colors = [azulPrincipal, roxo, rosa, verde, amarelo, vermelho];
    return colors[(nivel - 1) % colors.length];
  }

  // Cores para ranking (top 3)
  static Color getRankingColor(int posicao) {
    switch (posicao) {
      case 1:
        return amarelo; // Ouro
      case 2:
        return Colors.grey.shade400; // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return azulClaro;
    }
  }
}
