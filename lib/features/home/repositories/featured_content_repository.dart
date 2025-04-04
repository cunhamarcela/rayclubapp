import 'package:flutter/material.dart';
import 'package:ray_club_app/features/home/models/featured_content.dart';

/// Interface para o repositório de conteúdos em destaque
abstract class FeaturedContentRepository {
  /// Recupera a lista de conteúdos em destaque
  Future<List<FeaturedContent>> getFeaturedContents();
  
  /// Recupera um conteúdo específico pelo ID
  Future<FeaturedContent?> getFeaturedContentById(String id);
}

/// Implementação mock do repositório para desenvolvimento
class MockFeaturedContentRepository implements FeaturedContentRepository {
  @override
  Future<List<FeaturedContent>> getFeaturedContents() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      FeaturedContent(
        id: '1',
        title: 'Dicas de Nutrição',
        description: 'Como montar um prato ideal após o treino',
        category: ContentCategory(
          id: 'cat1',
          name: 'Nutrição',
          color: Colors.green,
          colorHex: '#4CAF50',
        ),
        icon: Icons.restaurant,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        isFeatured: true,
      ),
      FeaturedContent(
        id: '2',
        title: 'Treino HIIT de 20 minutos',
        description: 'Queime calorias em casa sem equipamentos',
        category: ContentCategory(
          id: 'cat2',
          name: 'Treinos',
          color: Colors.orange,
          colorHex: '#FF9800',
        ),
        icon: Icons.fitness_center,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        isFeatured: true,
      ),
      FeaturedContent(
        id: '3',
        title: 'Alongamento pós-treino',
        description: 'Técnicas para recuperação muscular eficiente',
        category: ContentCategory(
          id: 'cat3',
          name: 'Recuperação',
          color: Colors.blue,
          colorHex: '#2196F3',
        ),
        icon: Icons.self_improvement,
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      FeaturedContent(
        id: '4',
        title: 'Meditações guiadas',
        description: 'Reduza o estresse e melhore seu sono',
        category: ContentCategory(
          id: 'cat4',
          name: 'Bem-estar',
          color: Colors.purple,
          colorHex: '#9C27B0',
        ),
        icon: Icons.spa,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Future<FeaturedContent?> getFeaturedContentById(String id) async {
    final list = await getFeaturedContents();
    return list.where((content) => content.id == id).firstOrNull;
  }
}

/// Implementação real do repositório usando Supabase (para ser implementado futuramente)
class SupabaseFeaturedContentRepository implements FeaturedContentRepository {
  @override
  Future<List<FeaturedContent>> getFeaturedContents() async {
    // TODO: Implementar a lógica real com Supabase
    // Exemplo:
    // final response = await _supabaseClient
    //     .from('featured_contents')
    //     .select('*, category:categories(*)')
    //     .order('published_at', ascending: false)
    //     .execute();
    
    // Retornar mockados por enquanto
    return MockFeaturedContentRepository().getFeaturedContents();
  }

  @override
  Future<FeaturedContent?> getFeaturedContentById(String id) async {
    // TODO: Implementar a lógica real com Supabase
    // Exemplo:
    // final response = await _supabaseClient
    //     .from('featured_contents')
    //     .select('*, category:categories(*)')
    //     .eq('id', id)
    //     .single()
    //     .execute();
    
    // Retornar mockados por enquanto
    return MockFeaturedContentRepository().getFeaturedContentById(id);
  }
  
  // Helper para converter hex para Color (para quando implementar com dados reais)
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
} 