import 'package:flutter/material.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/home/models/home_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ray_club_app/core/services/cache_service.dart';

/// Interface para o repositório de dados da Home
abstract class HomeRepository {
  /// Recupera todos os dados necessários para a tela Home
  Future<HomeData> getHomeData();
  
  /// Recupera apenas os dados de progresso do usuário
  Future<UserProgress> getUserProgress();
  
  /// Recupera os banners promocionais
  Future<List<BannerItem>> getBanners();
  
  /// Recupera as categorias de treino
  Future<List<WorkoutCategory>> getWorkoutCategories();
  
  /// Recupera os treinos populares
  Future<List<PopularWorkout>> getPopularWorkouts();
}

/// Implementação mock do repositório para desenvolvimento
class MockHomeRepository implements HomeRepository {
  @override
  Future<HomeData> getHomeData() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    try {
      final banners = await getBanners();
      final progress = await getUserProgress();
      final categories = await getWorkoutCategories();
      final workouts = await getPopularWorkouts();
      
      return HomeData(
        activeBanner: banners.isNotEmpty ? banners.first : BannerItem.empty(),
        banners: banners,
        progress: progress,
        categories: categories,
        popularWorkouts: workouts,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw AppException(
        message: 'Erro ao carregar dados da Home',
        originalError: e,
      );
    }
  }
  
  @override
  Future<UserProgress> getUserProgress() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Dados mockados de progresso
    return const UserProgress(
      daysTrainedThisMonth: 12,
      currentStreak: 3,
      bestStreak: 7,
      challengeProgress: 40,
    );
  }
  
  @override
  Future<List<BannerItem>> getBanners() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Dados mockados de banners
    return [
      const BannerItem(
        id: '1',
        title: 'Novo Treino de HIIT',
        subtitle: 'Queime calorias em 20 minutos',
        imageUrl: 'assets/images/challenge_default.jpg',
        isActive: true,
      ),
      const BannerItem(
        id: '2',
        title: 'Parceiros com 30% OFF',
        subtitle: 'Produtos fitness com descontos exclusivos',
        imageUrl: 'assets/images/workout_default.jpg',
      ),
      const BannerItem(
        id: '3',
        title: 'Desafio do Mês',
        subtitle: 'Participe e concorra a prêmios',
        imageUrl: 'assets/images/banner_bemvindo.jpg',
      ),
    ];
  }
  
  @override
  Future<List<WorkoutCategory>> getWorkoutCategories() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Dados mockados de categorias
    return [
      const WorkoutCategory(
        id: 'cat1',
        name: 'Cardio',
        iconUrl: 'assets/icons/cardio.png',
        workoutCount: 12,
        colorHex: '#FF5252',
      ),
      const WorkoutCategory(
        id: 'cat2',
        name: 'Força',
        iconUrl: 'assets/icons/strength.png',
        workoutCount: 8,
        colorHex: '#448AFF',
      ),
      const WorkoutCategory(
        id: 'cat3',
        name: 'Flexibilidade',
        iconUrl: 'assets/icons/flexibility.png',
        workoutCount: 6,
        colorHex: '#9C27B0',
      ),
      const WorkoutCategory(
        id: 'cat4',
        name: 'HIIT',
        iconUrl: 'assets/icons/hiit.png',
        workoutCount: 4,
        colorHex: '#FF9800',
      ),
    ];
  }
  
  @override
  Future<List<PopularWorkout>> getPopularWorkouts() async {
    // Simulando um delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Dados mockados de treinos populares
    return [
      const PopularWorkout(
        id: 'workout1',
        title: 'Treino Full Body',
        imageUrl: 'assets/images/workout_fullbody.jpg',
        duration: '45 min',
        difficulty: 'Intermediário',
        favoriteCount: 245,
      ),
      const PopularWorkout(
        id: 'workout2',
        title: 'Abdômen Definido',
        imageUrl: 'assets/images/workout_abs.jpg',
        duration: '20 min',
        difficulty: 'Iniciante',
        favoriteCount: 189,
      ),
      const PopularWorkout(
        id: 'workout3',
        title: 'Cardio Intenso',
        imageUrl: 'assets/images/workout_cardio.jpg',
        duration: '30 min',
        difficulty: 'Avançado',
        favoriteCount: 136,
      ),
    ];
  }
}

/// Implementação real do repositório usando Supabase
class SupabaseHomeRepository implements HomeRepository {
  final SupabaseClient _supabaseClient;
  final CacheService _cacheService;
  
  // Chaves de cache
  static const String _cacheKeyHomeData = 'home_data';
  static const String _cacheKeyUserProgress = 'user_progress';
  static const String _cacheKeyBanners = 'banners';
  static const String _cacheKeyCategories = 'workout_categories';
  static const String _cacheKeyPopularWorkouts = 'popular_workouts';
  
  // Duração padrão para expiração de cache
  static const Duration _defaultCacheExpiry = Duration(minutes: 15);
  static const Duration _shortCacheExpiry = Duration(minutes: 5);
  
  SupabaseHomeRepository(this._supabaseClient, this._cacheService);

  @override
  Future<HomeData> getHomeData() async {
    try {
      // Verificar se há dados em cache
      final cachedData = await _cacheService.get(_cacheKeyHomeData);
      if (cachedData != null) {
        try {
          // Tentar construir o objeto HomeData com os dados em cache
          final cachedHomeData = HomeData.fromJson(cachedData);
          
          // Verificar se os dados não são muito antigos (15 minutos)
          final now = DateTime.now();
          final dataAge = now.difference(cachedHomeData.lastUpdated);
          
          if (dataAge < _defaultCacheExpiry) {
            return cachedHomeData;
          }
          
          // Se os dados são antigos, continuar com a busca remota,
          // mas manter o cache como fallback
        } catch (e) {
          // Se houver erro ao decodificar o cache, ignorar e buscar dados remotos
        }
      }
      
      // Executar todas as requisições em paralelo para otimizar o tempo de carregamento
      final results = await Future.wait([
        getBanners(),
        getUserProgress(),
        getWorkoutCategories(),
        getPopularWorkouts(),
      ]);
      
      // Extrair os resultados na ordem das requisições
      final banners = results[0] as List<BannerItem>;
      final progress = results[1] as UserProgress;
      final categories = results[2] as List<WorkoutCategory>;
      final workouts = results[3] as List<PopularWorkout>;
      
      final homeData = HomeData(
        activeBanner: banners.firstWhere(
          (banner) => banner.isActive, 
          orElse: () => banners.isNotEmpty ? banners.first : BannerItem.empty()
        ),
        banners: banners,
        progress: progress,
        categories: categories,
        popularWorkouts: workouts,
        lastUpdated: DateTime.now(),
      );
      
      // Armazenar em cache para uso futuro
      await _cacheService.set(
        _cacheKeyHomeData, 
        homeData.toJson(),
        expiry: _defaultCacheExpiry
      );
      
      return homeData;
    } catch (e) {
      // Em caso de erro, tentar usar o cache, mesmo se estiver expirado
      final cachedData = await _cacheService.get(_cacheKeyHomeData);
      if (cachedData != null) {
        try {
          return HomeData.fromJson(cachedData);
        } catch (_) {
          // Ignorar erros ao decodificar cache
        }
      }
      
      throw AppException(
        message: 'Erro ao carregar dados da Home',
        originalError: e,
      );
    }
  }
  
  @override
  Future<UserProgress> getUserProgress() async {
    try {
      // Verificar se há dados em cache
      final cachedData = await _cacheService.get(_cacheKeyUserProgress);
      if (cachedData != null) {
        try {
          // Cache de progresso tem validade curta (5 minutos)
          final cachedProgress = UserProgress.fromJson(cachedData);
          return cachedProgress;
        } catch (e) {
          // Se houver erro ao decodificar o cache, ignorar
        }
      }
      
      // Buscar dados remotos
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw AppException(
          message: 'Usuário não autenticado',
        );
      }
      
      final response = await _supabaseClient
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .single();
      
      // Se chegou até aqui, a resposta foi bem-sucedida
      final progress = UserProgress(
        daysTrainedThisMonth: response['days_trained_this_month'] ?? 0,
        currentStreak: response['current_streak'] ?? 0,
        bestStreak: response['best_streak'] ?? 0,
        challengeProgress: response['challenge_progress'] ?? 0,
      );
      
      // Armazenar em cache para uso futuro
      await _cacheService.set(
        _cacheKeyUserProgress, 
        progress.toJson(),
        expiry: _shortCacheExpiry
      );
      
      return progress;
    } catch (e) {
      // Em caso de erro, tentar usar o cache, mesmo se estiver expirado
      final cachedData = await _cacheService.get(_cacheKeyUserProgress);
      if (cachedData != null) {
        try {
          return UserProgress.fromJson(cachedData);
        } catch (_) {
          // Ignorar erros ao decodificar cache
        }
      }
      
      // Se for erro do Supabase, tenta extrair a mensagem específica
      if (e is PostgrestException) {
        throw AppException(
          message: 'Erro ao buscar progresso: ${e.message}',
          originalError: e,
        );
      }
      
      throw AppException(
        message: 'Erro ao carregar progresso do usuário',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<BannerItem>> getBanners() async {
    try {
      // Verificar se há dados em cache
      final cachedData = await _cacheService.get(_cacheKeyBanners);
      if (cachedData != null) {
        try {
          // Lista de banners pode ser usada do cache por até 15 minutos
          final cachedBanners = (cachedData as List)
            .map((item) => BannerItem.fromJson(item))
            .toList();
          return cachedBanners;
        } catch (e) {
          // Se houver erro ao decodificar o cache, ignorar
        }
      }
      
      // Buscar dados remotos
      final response = await _supabaseClient
        .from('banners')
        .select()
        .order('created_at', ascending: false);
      
      // Se a resposta estiver vazia, retornar lista vazia
      if (response == null || response.isEmpty) {
        return [];
      }
      
      // Converter os dados da resposta para objetos BannerItem
      final banners = response.map<BannerItem>((data) {
        return BannerItem(
          id: data['id'] ?? '',
          title: data['title'] ?? '',
          subtitle: data['subtitle'] ?? '',
          imageUrl: data['image_url'] ?? '',
          actionUrl: data['action_url'],
          isActive: data['is_active'] ?? false,
        );
      }).toList();
      
      // Armazenar em cache para uso futuro
      await _cacheService.set(
        _cacheKeyBanners, 
        banners.map((banner) => banner.toJson()).toList(),
        expiry: _defaultCacheExpiry
      );
      
      return banners;
    } catch (e) {
      // Em caso de erro, tentar usar o cache, mesmo se estiver expirado
      final cachedData = await _cacheService.get(_cacheKeyBanners);
      if (cachedData != null) {
        try {
          final cachedBanners = (cachedData as List)
            .map((item) => BannerItem.fromJson(item))
            .toList();
          return cachedBanners;
        } catch (_) {
          // Ignorar erros ao decodificar cache
        }
      }
      
      // Em caso de erro, logamos e relançamos com mensagem amigável
      throw AppException(
        message: 'Erro ao carregar banners',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<WorkoutCategory>> getWorkoutCategories() async {
    try {
      // Verificar se há dados em cache
      final cachedData = await _cacheService.get(_cacheKeyCategories);
      if (cachedData != null) {
        try {
          // Categorias podem ser usadas do cache por até 15 minutos
          final cachedCategories = (cachedData as List)
            .map((item) => WorkoutCategory.fromJson(item))
            .toList();
          return cachedCategories;
        } catch (e) {
          // Se houver erro ao decodificar o cache, ignorar
        }
      }
      
      // Buscar dados remotos
      final response = await _supabaseClient
        .from('workout_categories')
        .select()
        .order('name');
      
      // Se a resposta estiver vazia, retornar lista vazia
      if (response == null || response.isEmpty) {
        return [];
      }
      
      // Converter os dados da resposta para objetos WorkoutCategory
      final categories = response.map<WorkoutCategory>((data) {
        return WorkoutCategory(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          iconUrl: data['icon_url'] ?? '',
          workoutCount: data['workout_count'] ?? 0,
          colorHex: data['color_hex'],
        );
      }).toList();
      
      // Armazenar em cache para uso futuro
      await _cacheService.set(
        _cacheKeyCategories, 
        categories.map((category) => category.toJson()).toList(),
        expiry: _defaultCacheExpiry
      );
      
      return categories;
    } catch (e) {
      // Em caso de erro, tentar usar o cache, mesmo se estiver expirado
      final cachedData = await _cacheService.get(_cacheKeyCategories);
      if (cachedData != null) {
        try {
          final cachedCategories = (cachedData as List)
            .map((item) => WorkoutCategory.fromJson(item))
            .toList();
          return cachedCategories;
        } catch (_) {
          // Ignorar erros ao decodificar cache
        }
      }
      
      throw AppException(
        message: 'Erro ao carregar categorias',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<PopularWorkout>> getPopularWorkouts() async {
    try {
      // Verificar se há dados em cache
      final cachedData = await _cacheService.get(_cacheKeyPopularWorkouts);
      if (cachedData != null) {
        try {
          // Treinos populares podem ser usados do cache por até 15 minutos
          final cachedWorkouts = (cachedData as List)
            .map((item) => PopularWorkout.fromJson(item))
            .toList();
          return cachedWorkouts;
        } catch (e) {
          // Se houver erro ao decodificar o cache, ignorar
        }
      }
      
      // Buscar dados remotos
      final response = await _supabaseClient
        .from('workouts')
        .select()
        .eq('is_popular', true)
        .order('favorite_count', ascending: false)
        .limit(5);
      
      // Se a resposta estiver vazia, retornar lista vazia
      if (response == null || response.isEmpty) {
        return [];
      }
      
      // Converter os dados da resposta para objetos PopularWorkout
      final workouts = response.map<PopularWorkout>((data) {
        return PopularWorkout(
          id: data['id'] ?? '',
          title: data['title'] ?? '',
          imageUrl: data['image_url'] ?? '',
          duration: data['duration'] ?? '',
          difficulty: data['difficulty'] ?? '',
          favoriteCount: data['favorite_count'] ?? 0,
        );
      }).toList();
      
      // Armazenar em cache para uso futuro
      await _cacheService.set(
        _cacheKeyPopularWorkouts, 
        workouts.map((workout) => workout.toJson()).toList(),
        expiry: _defaultCacheExpiry
      );
      
      return workouts;
    } catch (e) {
      // Em caso de erro, tentar usar o cache, mesmo se estiver expirado
      final cachedData = await _cacheService.get(_cacheKeyPopularWorkouts);
      if (cachedData != null) {
        try {
          final cachedWorkouts = (cachedData as List)
            .map((item) => PopularWorkout.fromJson(item))
            .toList();
          return cachedWorkouts;
        } catch (_) {
          // Ignorar erros ao decodificar cache
        }
      }
      
      throw AppException(
        message: 'Erro ao carregar treinos populares',
        originalError: e,
      );
    }
  }
  
  // Helper para converter hex para Color
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
} 