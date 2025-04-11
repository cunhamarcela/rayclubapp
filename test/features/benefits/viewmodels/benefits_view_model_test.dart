// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/benefits/enums/benefit_type.dart';
import 'package:ray_club_app/features/benefits/models/benefit.dart';
import 'package:ray_club_app/features/benefits/repositories/benefits_repository.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefits_view_model.dart';

// Criando mocks para os testes
class MockBenefitsRepository extends Mock implements BenefitsRepository {}

void main() {
  late BenefitsViewModel viewModel;
  late MockBenefitsRepository mockRepository;

  // Dados de teste
  final testBenefits = [
    Benefit(
      id: '1',
      title: 'Desconto Academia',
      description: 'Desconto de 15% na mensalidade',
      imageUrl: 'https://example.com/gym.jpg',
      partner: 'Academia FitPlus',
      category: 'Fitness',
      pointsCost: 100,
      expirationDays: 30,
      isActive: true,
      redemptionCount: 0,
      createdAt: DateTime.now(),
    ),
    Benefit(
      id: '2',
      title: 'Sessão de Nutrição',
      description: 'Consulta gratuita com nutricionista',
      imageUrl: 'https://example.com/nutrition.jpg',
      partner: 'Clínica Nutrivida',
      category: 'Saúde',
      pointsCost: 200,
      expirationDays: 60,
      isActive: true,
      redemptionCount: 0,
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockRepository = MockBenefitsRepository();
    
    // Configuração padrão dos mocks
    when(() => mockRepository.getAllBenefits())
        .thenAnswer((_) async => testBenefits);
    
    // Inicialmente não inicializamos o viewModel para evitar
    // chamadas automáticas no construtor
  });

  group('BenefitsViewModel - loadBenefits', () {
    test('carrega benefícios com sucesso', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      
      // Act - loadBenefits é chamado automaticamente no construtor
      await Future.delayed(Duration.zero); // Permitir que chamadas assíncronas terminem
      
      // Assert
      verify(() => mockRepository.getAllBenefits()).called(1);
      
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.benefits.length, 2);
      expect(viewModel.state.filteredBenefits.length, 2);
      expect(viewModel.state.partners.length, 2); // Dois parceiros únicos
      expect(viewModel.state.errorMessage, isNull);
    });
    
    test('lida com erros ao carregar benefícios', () async {
      // Arrange
      when(() => mockRepository.getAllBenefits())
          .thenThrow(AppException(message: 'Falha ao carregar benefícios'));
      
      viewModel = BenefitsViewModel(mockRepository);
      
      // Act - loadBenefits é chamado automaticamente no construtor
      await Future.delayed(Duration.zero); // Permitir que chamadas assíncronas terminem
      
      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, contains('Falha ao carregar benefícios'));
    });
  });

  group('BenefitsViewModel - filterByType', () {
    test('filtra benefícios por tipo com sucesso', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      await Future.delayed(Duration.zero); // Aguardar loadBenefits no construtor
      
      final filteredBenefits = [testBenefits[0]]; // Apenas o primeiro benefício
      when(() => mockRepository.getBenefitsByType(BenefitType.coupon))
          .thenAnswer((_) async => filteredBenefits);
      
      // Act
      await viewModel.filterByType(BenefitType.coupon);
      
      // Assert
      verify(() => mockRepository.getBenefitsByType(BenefitType.coupon)).called(1);
      
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.filteredBenefits.length, 1);
      expect(viewModel.state.filteredBenefits.first.id, '1');
      expect(viewModel.state.activeTab, 'coupon');
      expect(viewModel.state.errorMessage, isNull);
    });
    
    test('lida com erros ao filtrar benefícios', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      await Future.delayed(Duration.zero); // Aguardar loadBenefits no construtor
      
      when(() => mockRepository.getBenefitsByType(BenefitType.coupon))
          .thenThrow(AppException(message: 'Falha ao filtrar benefícios'));
      
      // Act
      await viewModel.filterByType(BenefitType.coupon);
      
      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, contains('Falha ao filtrar benefícios'));
    });
  });

  group('BenefitsViewModel - showAllBenefits', () {
    test('exibe todos os benefícios sem filtro', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      await Future.delayed(Duration.zero); // Aguardar loadBenefits no construtor
      
      // Primeiro filtramos para depois mostrar todos
      final filteredBenefits = [testBenefits[0]]; // Apenas o primeiro benefício
      when(() => mockRepository.getBenefitsByType(BenefitType.coupon))
          .thenAnswer((_) async => filteredBenefits);
      
      await viewModel.filterByType(BenefitType.coupon);
      
      // Verificar que o filtro foi aplicado
      expect(viewModel.state.filteredBenefits.length, 1);
      
      // Act
      viewModel.showAllBenefits();
      
      // Assert
      expect(viewModel.state.filteredBenefits.length, 2); // Todos os benefícios
      expect(viewModel.state.activeTab, 'all');
    });
  });

  group('BenefitsViewModel - filterByPartner', () {
    test('filtra benefícios por parceiro', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      await Future.delayed(Duration.zero); // Aguardar loadBenefits no construtor
      
      // Act
      viewModel.filterByPartner('Academia FitPlus');
      
      // Assert
      expect(viewModel.state.filteredBenefits.length, 1);
      expect(viewModel.state.filteredBenefits.first.partner, 'Academia FitPlus');
    });
    
    test('retorna todos os benefícios quando parceiro é nulo ou vazio', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      await Future.delayed(Duration.zero); // Aguardar loadBenefits no construtor
      
      // Primeiro filtramos
      viewModel.filterByPartner('Academia FitPlus');
      expect(viewModel.state.filteredBenefits.length, 1);
      
      // Act - limpar filtro com valor nulo
      viewModel.filterByPartner(null);
      
      // Assert
      expect(viewModel.state.filteredBenefits.length, 2); // Todos os benefícios
      
      // Act - limpar filtro com valor vazio
      viewModel.filterByPartner('Academia FitPlus');
      viewModel.filterByPartner('');
      
      // Assert
      expect(viewModel.state.filteredBenefits.length, 2); // Todos os benefícios
    });
  });

  group('BenefitsViewModel - selectBenefit', () {
    test('seleciona um benefício', () async {
      // Arrange
      viewModel = BenefitsViewModel(mockRepository);
      await Future.delayed(Duration.zero); // Aguardar loadBenefits no construtor
      
      // Act
      viewModel.selectBenefit(testBenefits[1]);
      
      // Assert
      expect(viewModel.state.selectedBenefit, isNotNull);
      expect(viewModel.state.selectedBenefit?.id, '2');
      expect(viewModel.state.selectedBenefit?.title, 'Sessão de Nutrição');
    });
  });
} 