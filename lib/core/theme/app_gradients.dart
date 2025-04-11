// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'app_colors.dart';

/// Classe que define os gradientes utilizados no aplicativo
class AppGradients {
  // Gradiente principal - roxo
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente secundário - verde
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.secondary, Color(0xFF27EFC0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente laranja quente
  static const LinearGradient warmGradient = LinearGradient(
    colors: [AppColors.accent, Color(0xFFFF9566)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente para cards com fundo escuro
  static const LinearGradient darkOverlayGradient = LinearGradient(
    colors: [Colors.black54, Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0.0, 0.7],
  );
  
  // Gradiente suave para fundos claros
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [AppColors.backgroundLight, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Gradiente para destacar conteúdo
  static const LinearGradient highlightGradient = LinearGradient(
    colors: [AppColors.cream, AppColors.pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente para banners principais
  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xCCB062F9), Color(0xCCFF6B39)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Gradiente para botões especiais
  static const LinearGradient actionButtonGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Gradiente para cards com textura
  static const LinearGradient texturedCardGradient = LinearGradient(
    colors: [
      Color(0xFFF7F8FC),
      Color(0xFFF2F3F7),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
} 