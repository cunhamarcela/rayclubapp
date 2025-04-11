// Flutter imports:
import 'package:flutter/material.dart';

/// Classe que define as cores utilizadas no aplicativo
class AppColors {
  // Cores principais
  static const Color primary = Color(0xFFF3E7D7); // Bege claro principal
  static const Color primaryLight = Color(0xFFF8F1E7);
  static const Color primaryDark = Color(0xFFE3D7C7);
  static const Color secondary = Color(0xFFEE583F); // Vermelho secundário
  static const Color accent = Color(0xFFE78639); // Laranja para destaques (#E78639)
  
  // Backgrounds
  static const Color backgroundDark = Color(0xFF4D4D4D);
  static const Color backgroundMedium = Color(0xFF777777);
  static const Color backgroundLight = Color(0xFFF3E7D7); // Fundo claro principal
  static const Color backgroundSecondary = Color(0xFFE6E6E6); // Fundo secundário (cinza claro #E6E6E6)
  
  // Texto
  static const Color white = Colors.white;
  static const Color textLight = Color(0xFF8A8A8A); // Texto secundário
  static const Color textDark = Color(0xFF4D4D4D); // Texto primário (cinza escuro #4D4D4D)
  static const Color textSecondary = Color(0xFF777777); // Texto secundário
  
  // Estados
  static const Color success = Color(0xFFC7B65E); // Verde-oliva para sucesso (#C7B65E)
  static const Color error = Color(0xFFEE583F); // Vermelho oficial para erros (#EE583F)
  static const Color warning = Color(0xFFFFB176); // Laranja claro para avisos (#FFB176)
  static const Color info = Color(0xFFEABCBC); // Rosa claro para informações (#EABCBC)
  
  // Utilidades
  static const Color divider = Color(0xFFE6E6E6); // Divisor suave cor cinza claro
  
  // Cores adicionais da paleta
  static const Color cream = Color(0xFFF3E7D7); // Cor creme principal (#F3E7D7)
  static const Color pink = Color(0xFFEABCBC); // Cor rosa (#EABCBC)
  static const Color coral = Color(0xFFFFB176); // Cor coral/pêssego (#FFB176)
  static const Color charcoal = Color(0xFF4D4D4D); // Cinza escuro (#4D4D4D)
  
  // Gradientes
  static const List<Color> primaryGradient = [
    Color(0xFFF3E7D7), 
    Color(0xFFE3D7C7)
  ];
  
  static const List<Color> orangeGradient = [
    Color(0xFFE78639), 
    Color(0xFFFFB176)
  ];
  
  static const List<Color> warmGradient = [
    Color(0xFFF3E7D7),
    Color(0xFFEABCBC)
  ];
} 
