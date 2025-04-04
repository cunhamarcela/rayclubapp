import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/core/services/cache_service.dart';
import 'package:ray_club_app/features/home/models/home_model.dart';
import 'package:ray_club_app/features/home/repositories/home_repository.dart';
import 'package:ray_club_app/features/home/viewmodels/states/home_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider para o repositório da Home
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  // Para desenvolvimento, podemos usar o repositório mock
  // Em ambiente real, usamos a implementação com Supabase
  
  // Para ambiente de produção:
  final supabase = Supabase.instance.client;
  final cacheService = ref.watch(cacheServiceProvider);
  return SupabaseHomeRepository(supabase, cacheService);
  
  // Para testes:
  // return MockHomeRepository();
});

/// Provider para HomeViewModel
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeViewModel(repository);
});

/// ViewModel para a tela Home
class HomeViewModel extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeViewModel(this._repository) : super(HomeState.initial()) {
    loadHomeData();
  }

  /// Carrega todos os dados necessários para a tela Home
  Future<void> loadHomeData() async {
    try {
      state = HomeState.loading();
      
      final homeData = await _repository.getHomeData();
      
      // Atualiza o estado com os dados carregados
      state = HomeState.loaded(homeData);
    } on AppException catch (e) {
      state = HomeState.error(e.message);
    } catch (e) {
      state = HomeState.error('Erro ao carregar dados: ${e.toString()}');
    }
  }

  /// Atualiza o índice do banner atual
  void updateBannerIndex(int index) {
    if (state.data?.banners != null && 
        index >= 0 && 
        index < state.data!.banners.length) {
      state = state.copyWith(currentBannerIndex: index);
    }
  }
  
  /// Atualiza apenas os dados de progresso do usuário
  Future<void> refreshUserProgress() async {
    try {
      if (state.data == null) {
        await loadHomeData();
        return;
      }
      
      final progress = await _repository.getUserProgress();
      
      // Atualiza apenas o progresso, mantendo os outros dados
      state = state.copyWith(
        data: state.data!.copyWith(
          progress: progress,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      // Não alteramos o estado em caso de erro no refresh
      // apenas para não perdermos os dados já carregados
    }
  }
} 