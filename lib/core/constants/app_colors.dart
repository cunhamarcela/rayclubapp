// Flutter imports:
import 'package:flutter/material.dart';

/// Classe que define as cores utilizadas no aplicativo
class AppColors {
  // 🔹 Cores principais
  static const Color primary        = Color(0xFFF3E7D7); // Bege principal (#F3E7D7)
  static const Color primaryLight   = Color(0xFFF8F1E7); // Bege mais claro
  static const Color primaryDark    = Color(0xFFE3D7C7); // Bege mais escuro
  static const Color brown          = Color(0xFFE78639); // Laranja/marrom Ray Club (#E78639)
  static const Color offWhite       = Color(0xFFE6E6E6); // Cinza claro (#E6E6E6)
  static const Color white          = Colors.white;      // Branco puro

  // 🔹 Texto
  static const Color textDark       = Color(0xFF4D4D4D); // Texto em fundo claro (#4D4D4D)
  static const Color textLight      = Color(0xFFFFFFFF); // Texto em fundo escuro
  static const Color textMedium     = Color(0xFF777777); // Texto médio
  static const Color textHint       = Color(0xFF999999); // Texto de dica

  // 🔹 Background e containers
  static const Color background     = Color(0xFFF3E7D7); // Fundo geral (#F3E7D7)
  static const Color surface        = Colors.white;       // Cards

  // 🔹 Estados e feedbacks
  static const Color disabled       = Color(0xFFE6E6E6); // Cinza claro (#E6E6E6)
  static const Color success        = Color(0xFFC7B65E); // Verde-oliva (#C7B65E)
  static const Color error          = Color(0xFFEE583F); // Vermelho (#EE583F)
  static const Color warning        = Color(0xFFFFB176); // Laranja claro (#FFB176)
  static const Color info           = Color(0xFFEABCBC); // Rosa claro (#EABCBC)

  // 🔹 Estética
  static const Color shadow         = Color(0x1A4D4D4D); // Sombra leve
  static const Color shadowLight    = Color(0x0D4D4D4D); // Sombra mais leve

  // 🔹 Gradiente
  static const List<Color> primaryGradient = [
    Color(0xFFF3E7D7),
    Color(0xFFE3D7C7),
  ];
}
