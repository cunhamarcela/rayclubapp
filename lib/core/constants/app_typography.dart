// Flutter imports:
import 'package:flutter/material.dart';

/// Classe que define as tipografias utilizadas no aplicativo
class AppTypography {
  // Headings
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    fontFamily: 'Stinger',
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
    fontFamily: 'Stinger',
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
    fontFamily: 'Stinger',
  );
  
  // Alias para compatibilidade
  static const TextStyle headline = headingSmall;
  
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'CenturyGothic',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'CenturyGothic',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'CenturyGothic',
  );
  
  // Alias para compatibilidade
  static const TextStyle body = bodyMedium;
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.4,
    fontFamily: 'CenturyGothic',
  );
  
  // Button
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: 0.5,
    fontFamily: 'CenturyGothic',
  );
  
  // Label
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.25,
    fontFamily: 'CenturyGothic',
  );
} 