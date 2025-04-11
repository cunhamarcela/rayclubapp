// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:ray_club_app/features/benefits/models/redeemed_benefit.dart';
import 'package:ray_club_app/features/benefits/repositories/benefit_repository.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefit_state.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefit_view_model.dart';
import 'benefit_expiration_test.mocks.dart';

@GenerateMocks([BenefitRepository])

void main() {
  late MockBenefitRepository mockRepository;
  late BenefitViewModel viewModel;

  setUp(() {
    mockRepository = MockBenefitRepository();
    viewModel = BenefitViewModel(mockRepository);
  });

  group('Expiração de Benefícios', () {
    test('checkExpiredBenefits deve atualizar status para expirado quando a data de expiração passou', () async {
      // Arrange
      final now = DateTime.now();
      final expiredDate = now.subtract(const Duration(days: 1));
      final activeDate = now.add(const Duration(days: 1));
      
      final benefitActive = RedeemedBenefit(
        id: 'active-id',
        benefitId: 'benefit-1',
        userId: 'user-1',
        redeemedAt: now.subtract(const Duration(days: 10)),
        redemptionCode: 'ABC123',
        expiresAt: activeDate,
        status: RedemptionStatus.active,
      );
      
      final benefitExpired = RedeemedBenefit(
        id: 'expired-id',
        benefitId: 'benefit-2',
        userId: 'user-1',
        redeemedAt: now.subtract(const Duration(days: 15)),
        redemptionCode: 'DEF456',
        expiresAt: expiredDate,
        status: RedemptionStatus.active,
      );
      
      final benefitAlreadyExpired = RedeemedBenefit(
        id: 'already-expired-id',
        benefitId: 'benefit-3',
        userId: 'user-1',
        redeemedAt: now.subtract(const Duration(days: 20)),
        redemptionCode: 'GHI789',
        expiresAt: expiredDate,
        status: RedemptionStatus.expired,
      );
      
      final redeemedBenefits = [benefitActive, benefitExpired, benefitAlreadyExpired];
      
      // Configure mock para retornar o benefício atualizado
      when(mockRepository.updateBenefitStatus(
        benefitExpired.id, 
        RedemptionStatus.expired
      )).thenAnswer((_) async => benefitExpired.copyWith(
        status: RedemptionStatus.expired
      ));
      
      // Act
      await viewModel.checkExpiredBenefits(redeemedBenefits);
      
      // Assert
      verify(mockRepository.updateBenefitStatus(
        benefitExpired.id, 
        RedemptionStatus.expired
      )).called(1);
      
      // Não deve tentar atualizar o benefício que já está expirado
      verifyNever(mockRepository.updateBenefitStatus(
        benefitAlreadyExpired.id, 
        RedemptionStatus.expired
      ));
      
      // Não deve tentar atualizar o benefício ativo com data futura
      verifyNever(mockRepository.updateBenefitStatus(
        benefitActive.id, 
        any
      ));
    });
    
    test('loadRedeemedBenefits deve verificar expiração', () async {
      // Arrange
      final benefits = <RedeemedBenefit>[];
      
      when(mockRepository.getRedeemedBenefits())
        .thenAnswer((_) async => benefits);
      
      // Act
      await viewModel.loadRedeemedBenefits();
      
      // Assert
      verify(mockRepository.getRedeemedBenefits()).called(1);
      
      // Verifica se o estado foi atualizado corretamente
      expect(viewModel.state.redeemedBenefits, equals(benefits));
      expect(viewModel.state.isLoading, equals(false));
    });
  });
} 
