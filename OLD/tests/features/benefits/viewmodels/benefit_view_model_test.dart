import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/benefits/models/benefit.dart';
import 'package:ray_club_app/features/benefits/models/redeemed_benefit.dart';
import 'package:ray_club_app/features/benefits/repositories/benefit_repository.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefit_view_model.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefit_state.dart';

class MockBenefitRepository extends Mock implements BenefitRepository {}

void main() {
  late BenefitViewModel viewModel;
  late MockBenefitRepository mockRepository;

  // Dados de teste
  final testBenefits = [
    Benefit(
      id: 'benefit-1',
      title: 'Desconto em Suplementos',
      description: 'Desconto de 15% em todos os suplementos',
      imageUrl: 'https://example.com/image1.jpg',
      pointsRequired: 100,
      category: 'Suplementos',
    ),
    Benefit(
      id: 'benefit-2',
      title: 'Avaliação Física Gratuita',
      description: 'Uma avaliação física completa grátis',
      imageUrl: 'https://example.com/image2.jpg',
      pointsRequired: 200,
      category: 'Fitness',
    ),
  ];

  final testRedeemedBenefit = RedeemedBenefit(
    id: 'redeemed-1',
    benefitId: 'benefit-1',
    userId: 'user-1',
    redeemedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(days: 30)),
    redemptionCode: 'ABC123',
    benefitSnapshot: testBenefits[0],
  );

  setUp(() {
    mockRepository = MockBenefitRepository();
    viewModel = BenefitViewModel(mockRepository);
  });

  group('BenefitViewModel', () {
    test('estado inicial deve ser BenefitState padrão', () {
      expect(viewModel.state, const BenefitState());
    });

    group('loadBenefits', () {
      test('deve atualizar o estado com benefícios e categorias quando sucesso', () async {
        // Arrange
        when(() => mockRepository.getBenefits())
            .thenAnswer((_) async => testBenefits);
        when(() => mockRepository.getBenefitCategories())
            .thenAnswer((_) async => ['Suplementos', 'Fitness']);

        // Act
        await viewModel.loadBenefits();

        // Assert
        verify(() => mockRepository.getBenefits()).called(1);
        verify(() => mockRepository.getBenefitCategories()).called(1);
        
        expect(viewModel.state.benefits, testBenefits);
        expect(viewModel.state.categories, ['Suplementos', 'Fitness']);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, null);
      });

      test('deve atualizar o estado com erro quando ocorre uma exceção', () async {
        // Arrange
        when(() => mockRepository.getBenefits())
            .thenThrow(AppException(message: 'Erro ao carregar benefícios'));
        when(() => mockRepository.getBenefitCategories())
            .thenAnswer((_) async => ['Suplementos', 'Fitness']);

        // Act
        await viewModel.loadBenefits();

        // Assert
        verify(() => mockRepository.getBenefits()).called(1);
        verifyNever(() => mockRepository.getBenefitCategories());
        
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, 'Erro ao carregar benefícios');
      });
    });

    group('loadRedeemedBenefits', () {
      test('deve atualizar o estado com benefícios resgatados quando sucesso', () async {
        // Arrange
        when(() => mockRepository.getRedeemedBenefits())
            .thenAnswer((_) async => [testRedeemedBenefit]);

        // Act
        await viewModel.loadRedeemedBenefits();

        // Assert
        verify(() => mockRepository.getRedeemedBenefits()).called(1);
        
        expect(viewModel.state.redeemedBenefits, [testRedeemedBenefit]);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, null);
      });

      test('deve atualizar o estado com erro quando ocorre uma exceção', () async {
        // Arrange
        when(() => mockRepository.getRedeemedBenefits())
            .thenThrow(AppException(message: 'Erro ao carregar benefícios resgatados'));

        // Act
        await viewModel.loadRedeemedBenefits();

        // Assert
        verify(() => mockRepository.getRedeemedBenefits()).called(1);
        
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, 'Erro ao carregar benefícios resgatados');
      });
    });

    group('filterByCategory', () {
      test('deve filtrar benefícios por categoria quando sucesso', () async {
        // Arrange
        final filteredBenefits = [testBenefits[0]]; // Apenas o benefício da categoria 'Suplementos'
        
        when(() => mockRepository.getBenefitsByCategory('Suplementos'))
            .thenAnswer((_) async => filteredBenefits);

        // Act
        await viewModel.filterByCategory('Suplementos');

        // Assert
        verify(() => mockRepository.getBenefitsByCategory('Suplementos')).called(1);
        
        expect(viewModel.state.benefits, filteredBenefits);
        expect(viewModel.state.selectedCategory, 'Suplementos');
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, null);
      });

      test('deve carregar todos os benefícios quando categoria é null', () async {
        // Arrange
        when(() => mockRepository.getBenefits())
            .thenAnswer((_) async => testBenefits);

        // Act
        await viewModel.filterByCategory(null);

        // Assert
        verify(() => mockRepository.getBenefits()).called(1);
        verifyNever(() => mockRepository.getBenefitsByCategory(any()));
        
        expect(viewModel.state.benefits, testBenefits);
        expect(viewModel.state.selectedCategory, null);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, null);
      });
    });

    group('selectBenefit', () {
      test('deve selecionar um benefício quando existe', () async {
        // Arrange
        when(() => mockRepository.getBenefitById('benefit-1'))
            .thenAnswer((_) async => testBenefits[0]);

        // Act
        await viewModel.selectBenefit('benefit-1');

        // Assert
        verify(() => mockRepository.getBenefitById('benefit-1')).called(1);
        
        expect(viewModel.state.selectedBenefit, testBenefits[0]);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, null);
      });

      test('deve atualizar o estado com erro quando benefício não encontrado', () async {
        // Arrange
        when(() => mockRepository.getBenefitById('invalid-id'))
            .thenAnswer((_) async => null);

        // Act
        await viewModel.selectBenefit('invalid-id');

        // Assert
        verify(() => mockRepository.getBenefitById('invalid-id')).called(1);
        
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.errorMessage, 'Benefício não encontrado');
      });
    });

    group('redeemBenefit', () {
      setUp(() {
        // Setup para ter um benefício válido
        when(() => mockRepository.getBenefitById('benefit-1'))
            .thenAnswer((_) async => testBenefits[0]);
        when(() => mockRepository.hasEnoughPoints('benefit-1'))
            .thenAnswer((_) async => true);
      });
      
      test('deve resgatar um benefício quando tem pontos suficientes', () async {
        // Arrange
        when(() => mockRepository.redeemBenefit('benefit-1'))
            .thenAnswer((_) async => testRedeemedBenefit);
        when(() => mockRepository.getRedeemedBenefits())
            .thenAnswer((_) async => [testRedeemedBenefit]);

        // Act
        final result = await viewModel.redeemBenefit('benefit-1');

        // Assert
        verify(() => mockRepository.getBenefitById('benefit-1')).called(1);
        verify(() => mockRepository.hasEnoughPoints('benefit-1')).called(1);
        verify(() => mockRepository.redeemBenefit('benefit-1')).called(1);
        verify(() => mockRepository.getRedeemedBenefits()).called(1);
        
        expect(result, testRedeemedBenefit);
        expect(viewModel.state.isRedeeming, false);
        expect(viewModel.state.benefitBeingRedeemed, null);
        expect(viewModel.state.redeemedBenefits, [testRedeemedBenefit]);
        expect(viewModel.state.selectedRedeemedBenefit, testRedeemedBenefit);
        expect(viewModel.state.errorMessage, null);
      });

      test('deve falhar ao resgatar quando não tem pontos suficientes', () async {
        // Arrange
        when(() => mockRepository.hasEnoughPoints('benefit-1'))
            .thenAnswer((_) async => false);

        // Act
        final result = await viewModel.redeemBenefit('benefit-1');

        // Assert
        verify(() => mockRepository.getBenefitById('benefit-1')).called(1);
        verify(() => mockRepository.hasEnoughPoints('benefit-1')).called(1);
        verifyNever(() => mockRepository.redeemBenefit('benefit-1'));
        
        expect(result, null);
        expect(viewModel.state.isRedeeming, false);
        expect(viewModel.state.benefitBeingRedeemed, null);
        expect(viewModel.state.errorMessage, 'Pontos insuficientes para resgatar este benefício');
      });
    });
  });
} 