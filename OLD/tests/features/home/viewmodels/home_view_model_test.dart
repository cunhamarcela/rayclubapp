import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/core/services/cache_service.dart';
import 'package:ray_club_app/features/home/models/home_model.dart';
import 'package:ray_club_app/features/home/repositories/home_repository.dart';
import 'package:ray_club_app/features/home/viewmodels/home_view_model.dart';
import 'package:ray_club_app/features/home/viewmodels/states/home_state.dart';
import 'dart:async';

// Mock do repositório
class MockHomeRepository extends Mock implements HomeRepository {}

// Mock do serviço de cache
class MockCacheService extends Mock implements CacheService {}

void main() {
  late HomeViewModel viewModel;
  late MockHomeRepository mockRepository;
  
  // Dados de teste
  final bannerItem1 = BannerItem(
    id: '1',
    title: 'Banner 1',
    subtitle: 'Descrição 1',
    imageUrl: 'https://example.com/banner1.jpg',
  );
  
  final bannerItem2 = BannerItem(
    id: '2',
    title: 'Banner 2',
    subtitle: 'Descrição 2',
    imageUrl: 'https://example.com/banner2.jpg',
  );
  
  final testHomeData = HomeData(
    activeBanner: bannerItem1,
    banners: [bannerItem1, bannerItem2],
    progress: const UserProgress(
      daysTrainedThisMonth: 15,
      currentStreak: 5,
      bestStreak: 10,
      challengeProgress: 30,
    ),
    categories: [
      WorkoutCategory(
        id: '1',
        name: 'Cardio',
        iconUrl: 'https://example.com/cardio.png',
        workoutCount: 10,
      ),
      WorkoutCategory(
        id: '2',
        name: 'Força',
        iconUrl: 'https://example.com/forca.png',
        workoutCount: 15,
      ),
    ],
    popularWorkouts: [
      PopularWorkout(
        id: '1',
        title: 'Treino HIIT',
        imageUrl: 'https://example.com/hiit.jpg',
        duration: '30 min',
        difficulty: 'Intermediário',
      ),
      PopularWorkout(
        id: '2',
        title: 'Core Training',
        imageUrl: 'https://example.com/core.jpg',
        duration: '20 min',
        difficulty: 'Iniciante',
      ),
    ],
    lastUpdated: DateTime.now(),
  );
  
  final testUserProgress = const UserProgress(
    daysTrainedThisMonth: 20,
    currentStreak: 7,
    bestStreak: 10,
    challengeProgress: 45,
  );

  setUp(() {
    mockRepository = MockHomeRepository();
    
    // Configuração padrão do repository mock
    when(() => mockRepository.getHomeData())
        .thenAnswer((_) async => testHomeData);
    
    when(() => mockRepository.getUserProgress())
        .thenAnswer((_) async => testUserProgress);
    
    viewModel = HomeViewModel(mockRepository);
  });

  group('HomeViewModel Tests', () {
    test('estado inicial deve ser loading e carregar dados automaticamente', () {
      // O ViewModel inicia o carregamento no construtor
      expect(viewModel.state, isA<HomeState>());
      
      // Verificar se loadHomeData foi chamado no construtor
      verify(() => mockRepository.getHomeData()).called(1);
    });

    test('loadHomeData deve atualizar o estado com dados da home', () async {
      // Usando Completer para evitar timing issues
      final completer = Completer<HomeData>();
      when(() => mockRepository.getHomeData())
          .thenAnswer((_) => completer.future);
      
      // Resetar o estado
      viewModel = HomeViewModel(mockRepository);
      
      // O estado inicial deve ser carregando
      expect(viewModel.state.isLoading, isTrue);
      
      // Completar a Future para simular a resposta do servidor
      completer.complete(testHomeData);
      
      // Aguardar a conclusão do loadHomeData
      await pumpEventQueue();
      
      // Verificar se o estado está carregado corretamente
      expect(viewModel.state.isLoading, equals(false));
      expect(viewModel.state.data, equals(testHomeData));
      expect(viewModel.state.error, isNull);
    });
    
    test('loadHomeData deve tratar erros corretamente', () async {
      // Usando Completer para evitar timing issues
      final completer = Completer<HomeData>();
      when(() => mockRepository.getHomeData())
          .thenAnswer((_) => completer.future);
      
      // Criar um novo ViewModel para testar o caso de erro
      viewModel = HomeViewModel(mockRepository);
      
      // Falhar a Future para simular um erro do servidor
      completer.completeError(const AppException(message: 'Erro ao carregar dados da home'));
      
      // Aguardar a conclusão do loadHomeData
      await pumpEventQueue();
      
      // Verificar se o estado de erro foi configurado corretamente
      expect(viewModel.state.isLoading, equals(false));
      expect(viewModel.state.error, equals('Erro ao carregar dados da home'));
      expect(viewModel.state.data, isNull);
    });
    
    test('updateBannerIndex deve atualizar o índice do banner', () async {
      // Primeiro carregar os dados para ter um estado loaded
      await viewModel.loadHomeData();
      
      // O índice default é 0
      expect(viewModel.state.currentBannerIndex, equals(0));
      
      // Atualizar para o índice 1
      viewModel.updateBannerIndex(1);
      
      // Verificar se o índice foi atualizado
      expect(viewModel.state.currentBannerIndex, equals(1));
      
      // Verificar que o restante do estado permanece inalterado
      expect(viewModel.state.isLoading, equals(false));
      expect(viewModel.state.data, equals(testHomeData));
    });
    
    test('updateBannerIndex não deve atualizar para índice inválido', () async {
      // Primeiro carregar os dados para ter um estado loaded
      await viewModel.loadHomeData();
      
      // O índice default é 0
      expect(viewModel.state.currentBannerIndex, equals(0));
      
      // Tentar atualizar para um índice negativo
      viewModel.updateBannerIndex(-1);
      
      // Verificar que o índice permanece inalterado
      expect(viewModel.state.currentBannerIndex, equals(0));
      
      // Tentar atualizar para um índice maior que o número de banners
      viewModel.updateBannerIndex(5);
      
      // Verificar que o índice permanece inalterado
      expect(viewModel.state.currentBannerIndex, equals(0));
    });
    
    test('refreshUserProgress deve atualizar apenas o progresso do usuário', () async {
      // Primeiro carregar os dados para ter um estado loaded
      await viewModel.loadHomeData();
      
      // Salvar o estado original
      final originalData = viewModel.state.data;
      
      // Configurar o comportamento do mock para getUserProgress()
      when(() => mockRepository.getUserProgress())
          .thenAnswer((_) async => testUserProgress);
      
      // Atualizar o progresso
      await viewModel.refreshUserProgress();
      
      // Verificar que apenas o progresso foi atualizado
      expect(viewModel.state.data?.progress, equals(testUserProgress));
      
      // Verificar que os outros dados permanecem inalterados
      expect(viewModel.state.data?.banners, equals(originalData?.banners));
      expect(viewModel.state.data?.popularWorkouts, equals(originalData?.popularWorkouts));
      expect(viewModel.state.data?.categories, equals(originalData?.categories));
      
      // A data de atualização deve ser modificada
      expect(viewModel.state.data?.lastUpdated, isNot(equals(originalData?.lastUpdated)));
    });
    
    test('refreshUserProgress deve carregar todos os dados se o estado ainda não tiver dados', () async {
      // Simular um estado sem dados (initial)
      when(() => mockRepository.getHomeData())
          .thenAnswer((_) async => testHomeData);
          
      viewModel = HomeViewModel(mockRepository);
      
      // Resetar as mock calls
      reset(mockRepository);
      
      // Configurar o comportamento esperado
      when(() => mockRepository.getHomeData())
          .thenAnswer((_) async => testHomeData);
      
      // Chamar refreshUserProgress
      await viewModel.refreshUserProgress();
      
      // Verificar que loadHomeData foi chamado
      verify(() => mockRepository.getHomeData()).called(1);
      
      // Verificar que o estado foi atualizado com todos os dados
      expect(viewModel.state.isLoading, equals(false));
      expect(viewModel.state.data, equals(testHomeData));
    });
    
    test('refreshUserProgress não deve modificar o estado em caso de erro', () async {
      // Primeiro carregar os dados para ter um estado loaded
      await viewModel.loadHomeData();
      
      // Salvar o estado original
      final originalState = viewModel.state;
      
      // Configurar o mock para lançar uma exceção
      when(() => mockRepository.getUserProgress())
          .thenThrow(Exception('Erro ao carregar progresso'));
      
      // Atualizar o progresso
      await viewModel.refreshUserProgress();
      
      // Verificar que o estado permanece inalterado
      expect(viewModel.state, equals(originalState));
    });
  });
  
  group('SupabaseHomeRepository com Cache Tests', () {
    late MockCacheService mockCacheService;
    
    setUp(() {
      mockCacheService = MockCacheService();
      
      // Configurar comportamento padrão do cache
      when(() => mockCacheService.get(any())).thenAnswer((_) async => null);
      when(() => mockCacheService.set(any(), any(), expiry: any(named: 'expiry')))
          .thenAnswer((_) async => true);
    });
    
    test('SupabaseHomeRepository deve usar cache quando disponível', () async {
      // Este teste requer uma implementação com Supabase
      // e será executado em ambiente de integração
    });
  });
} 