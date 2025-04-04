import 'package:flutter/material.dart';

/// Classe que define as cores utilizadas no aplicativo
class AppColors {
  // 🔹 Cores principais
  static const Color primary        = Color(0xFFB2EBF2);
  static const Color primaryLight   = Color(0xFFE0F7FA);
  static const Color primaryDark    = Color(0xFF80DEEA);
  static const Color brown          = Color(0xFF795548); // Marrom Ray Club
  static const Color offWhite       = Color(0xFFFAF9F6); // Branco suave / bege claro
  static const Color white          = Colors.white;      // Branco puro

  // 🔹 Texto
  static const Color textDark       = Color(0xFF333333); // Texto em fundo claro
  static const Color textLight      = Color(0xFF666666); // Texto em fundo escuro
  static const Color textHint       = Color(0xFF999999); // Texto de dica

  // 🔹 Background e containers
  static const Color background     = Color(0xFFF5F5F5); // Fundo geral
  static const Color surface        = Colors.white;       // Cards

  // 🔹 Estados e feedbacks
  static const Color disabled       = Color(0xFFCCCCCC);
  static const Color success        = Color(0xFF4CAF50);
  static const Color error          = Color(0xFFE57373);
  static const Color warning        = Color(0xFFFFB74D);
  static const Color info           = Color(0xFF64B5F6);

  // 🔹 Estética
  static const Color shadow         = Color(0x1A000000); // Sombra leve
  static const Color shadowLight    = Color(0x0D000000); // Sombra mais leve

  // 🔹 Gradiente
  static const List<Color> primaryGradient = [
    Color(0xFFB2EBF2),
    Color(0xFF80DEEA),
  ];
}