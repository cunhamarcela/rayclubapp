import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'featured_content.freezed.dart';
part 'featured_content.g.dart';

/// Conversor personalizado para IconData
class IconDataConverter implements JsonConverter<IconData, String> {
  const IconDataConverter();

  @override
  IconData fromJson(String json) {
    // Converte o código codePoint em hexadecimal para um IconData
    return IconData(
      int.parse(json, radix: 16),
      fontFamily: 'MaterialIcons',
    );
  }

  @override
  String toJson(IconData iconData) {
    // Converte o codePoint para uma string hexadecimal
    return iconData.codePoint.toRadixString(16);
  }
}

/// Modelo que representa conteúdos em destaque na tela inicial
@freezed
class FeaturedContent with _$FeaturedContent {
  const factory FeaturedContent({
    required String id,
    required String title,
    required String description,
    required ContentCategory category,
    @IconDataConverter() required IconData icon,
    String? imageUrl,
    String? actionUrl,
    DateTime? publishedAt,
    @Default(false) bool isFeatured,
  }) = _FeaturedContent;

  factory FeaturedContent.fromJson(Map<String, dynamic> json) => _$FeaturedContentFromJson(json);
}

/// Categoria de conteúdo com nome e cor
@freezed
class ContentCategory with _$ContentCategory {
  const factory ContentCategory({
    @Default('') String id,
    required String name,
    @JsonKey(ignore: true) Color? color,
    String? colorHex,
  }) = _ContentCategory;
  
  factory ContentCategory.fromJson(Map<String, dynamic> json) => _$ContentCategoryFromJson(json);
}

/// Dados mockados para a exibição dos conteúdos em destaque
final List<FeaturedContent> featuredContents = [
  FeaturedContent(
    id: '1',
    title: 'Dicas de Nutrição',
    description: 'Como montar um prato ideal após o treino',
    category: ContentCategory(
      id: 'nutrition',
      name: 'Nutrição',
      color: Colors.green,
      colorHex: '#4CAF50',
    ),
    icon: Icons.restaurant,
  ),
  FeaturedContent(
    id: '2',
    title: 'Treino HIIT de 20 minutos',
    description: 'Queime calorias em casa sem equipamentos',
    category: ContentCategory(
      id: 'training',
      name: 'Treinos',
      color: Colors.orange,
      colorHex: '#FF9800',
    ),
    icon: Icons.fitness_center,
  ),
  FeaturedContent(
    id: '3',
    title: 'Alongamento pós-treino',
    description: 'Técnicas para recuperação muscular eficiente',
    category: ContentCategory(
      id: 'recovery',
      name: 'Recuperação',
      color: Colors.blue,
      colorHex: '#2196F3',
    ),
    icon: Icons.self_improvement,
  ),
  FeaturedContent(
    id: '4',
    title: 'Meditações guiadas',
    description: 'Reduza o estresse e melhore seu sono',
    category: ContentCategory(
      id: 'wellness',
      name: 'Bem-estar',
      color: Colors.purple,
      colorHex: '#9C27B0',
    ),
    icon: Icons.spa,
  ),
]; 