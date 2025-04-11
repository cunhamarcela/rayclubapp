// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:ray_club_app/features/benefits/models/benefit.dart';
import 'package:ray_club_app/features/benefits/models/redeemed_benefit.dart';
import 'package:ray_club_app/features/benefits/repositories/benefit_repository.dart';
import 'package:ray_club_app/features/benefits/screens/benefit_admin_screen.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefit_state.dart';
import 'package:ray_club_app/features/benefits/viewmodels/benefit_view_model.dart';
import 'package:ray_club_app/features/benefits/widgets/custom_date_picker.dart';
import 'benefit_admin_screen_test.mocks.dart';

@GenerateMocks([BenefitRepository])

class MockBenefitViewModel extends StateNotifier<BenefitState> implements BenefitViewModel {
  final MockBenefitRepository repository;
  
  MockBenefitViewModel(this.repository) : super(const BenefitState());
  
  @override
  Future<bool> isAdmin() async {
    return true; // Fingir que é admin para o teste
  }
  
  @override
  Future<void> loadAllRedeemedBenefits() async {
    state = state.copyWith(
      redeemedBenefits: [
        RedeemedBenefit(
          id: 'redeemed-1',
          benefitId: 'benefit-1',
          userId: 'user-1',
          redeemedAt: DateTime.now().subtract(const Duration(days: 5)),
          redemptionCode: 'CODE123',
          status: RedemptionStatus.active,
          expiresAt: DateTime.now().add(const Duration(days: 30)),
          benefitSnapshot: {
            'title': 'Test Benefit',
            'partner': 'Test Partner'
          },
        ),
        RedeemedBenefit(
          id: 'redeemed-2',
          benefitId: 'benefit-2',
          userId: 'user-2',
          redeemedAt: DateTime.now().subtract(const Duration(days: 10)),
          redemptionCode: 'CODE456',
          status: RedemptionStatus.expired,
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
          benefitSnapshot: {
            'title': 'Expired Benefit',
            'partner': 'Another Partner'
          },
        ),
      ],
    );
  }
  
  @override
  Future<bool> updateBenefitExpiration(String benefitId, DateTime? newExpirationDate) async {
    return true;
  }
  
  @override
  Future<bool> extendRedeemedBenefitExpiration(String redeemedBenefitId, DateTime? newExpirationDate) async {
    // Simula atualização bem-sucedida
    final updatedBenefit = state.redeemedBenefits
        .firstWhere((b) => b.id == redeemedBenefitId)
        .copyWith(expiresAt: newExpirationDate);
    
    final updatedList = [...state.redeemedBenefits];
    final index = updatedList.indexWhere((b) => b.id == redeemedBenefitId);
    updatedList[index] = updatedBenefit;
    
    state = state.copyWith(
      redeemedBenefits: updatedList,
      selectedRedeemedBenefit: updatedBenefit,
    );
    
    return true;
  }
  
  @override
  Future<void> loadBenefits() async {
    state = state.copyWith(
      benefits: [
        Benefit(
          id: 'benefit-1',
          title: 'Test Benefit',
          description: 'Test Description',
          partner: 'Test Partner',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
        Benefit(
          id: 'benefit-2',
          title: 'Another Benefit',
          description: 'Another Description',
          partner: 'Another Partner',
          expiresAt: null,
        ),
      ],
    );
  }
  
  @override
  Future<void> selectBenefit(String benefitId) async {
    final benefit = state.benefits.firstWhere((b) => b.id == benefitId);
    state = state.copyWith(selectedBenefit: benefit);
  }
  
  @override
  Future<void> selectRedeemedBenefit(String redeemedBenefitId) async {
    final benefit = state.redeemedBenefits.firstWhere((b) => b.id == redeemedBenefitId);
    state = state.copyWith(selectedRedeemedBenefit: benefit);
  }
  
  // Implementações necessárias (que não são usadas diretamente nestes testes)
  @override
  Future<void> addUserPoints(int points) async {}
  
  @override
  Future<void> cancelRedeemedBenefit(String redeemedBenefitId) async {}
  
  @override
  Future<void> checkExpiredBenefits(List<RedeemedBenefit> benefits) async {}
  
  @override
  void clearError() {}
  
  @override
  void clearSelectedBenefit() {}
  
  @override
  void clearSelectedRedeemedBenefit() {}
  
  @override
  Future<void> filterByCategory(String? category) async {}
  
  @override
  Future<List<String>> getBenefitCategories() async => [];
  
  @override
  Future<void> loadFeaturedBenefits() async {}
  
  @override
  Future<void> loadRedeemedBenefits() async {}
  
  @override
  Future<bool> markBenefitAsUsed(String redeemedBenefitId) async => true;
  
  @override
  Future<RedeemedBenefit?> redeemBenefit(String benefitId) async => null;
  
  @override
  BenefitViewModel copyWith({BenefitState? state}) {
    return this;
  }

  @override
  String _handleError(Object error, StackTrace stackTrace) => '';
  
  @override
  Future<void> toggleAdminStatus() async {}
}

void main() {
  late MockBenefitRepository mockRepository;
  late MockBenefitViewModel mockViewModel;
  late ProviderContainer container;
  
  setUp(() {
    mockRepository = MockBenefitRepository();
    mockViewModel = MockBenefitViewModel(mockRepository);
    
    // Configurar o container com providers de teste
    container = ProviderContainer(
      overrides: [
        benefitViewModelProvider.overrideWith((_) => mockViewModel),
      ],
    );
  });
  
  tearDown(() {
    container.dispose();
  });
  
  testWidgets('BenefitAdminScreen carrega com abas', (WidgetTester tester) async {
    // Preparar: Simular verificação de admin
    when(mockRepository.isAdmin()).thenAnswer((_) async => true);
    
    // Renderizar o widget com um ProviderScope para usar o container de teste
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: BenefitAdminScreen(),
        ),
      ),
    );
    
    // Aguardar carregamento
    await tester.pumpAndSettle();
    
    // Verificar se a tela carregou corretamente com suas abas
    expect(find.text('Admin - Ray Club'), findsOneWidget);
    expect(find.text('Benefícios'), findsOneWidget);
    expect(find.text('Resgatados'), findsOneWidget);
  });
  
  testWidgets('BenefitAdminScreen mostra benefícios na primeira aba', (WidgetTester tester) async {
    // Preparar: Simular verificação de admin
    when(mockRepository.isAdmin()).thenAnswer((_) async => true);
    
    // Renderizar o widget com um ProviderScope para usar o container de teste
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: BenefitAdminScreen(),
        ),
      ),
    );
    
    // Aguardar carregamento inicial e chamadas assíncronas
    await tester.pumpAndSettle();
    
    // Verificar se os benefícios são exibidos
    expect(find.text('Test Benefit'), findsOneWidget);
    expect(find.text('Another Benefit'), findsOneWidget);
  });
  
  testWidgets('BenefitAdminScreen permite alterar a data de expiração de um benefício', (WidgetTester tester) async {
    // Preparar: Simular verificação de admin
    when(mockRepository.isAdmin()).thenAnswer((_) async => true);
    
    // Renderizar o widget
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: BenefitAdminScreen(),
        ),
      ),
    );
    
    // Aguardar carregamento inicial
    await tester.pumpAndSettle();
    
    // Tocar no primeiro benefício para selecioná-lo
    await tester.tap(find.text('Test Benefit').first);
    await tester.pumpAndSettle();
    
    // Encontrar e tocar no botão de editar data
    await tester.tap(find.byIcon(Icons.edit_calendar).first);
    await tester.pumpAndSettle();
    
    // Verificar se o DatePicker aparece
    expect(find.byType(CustomDatePicker), findsOneWidget);
    
    // Tocar no botão "OK" para confirmar a nova data
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    
    // Verificar se a chamada para atualizar foi feita
    // Como estamos usando um mock, não podemos verificar a UI atualizada diretamente
    // Mas podemos verificar que não há erros e que a tela voltou ao estado normal
    expect(find.byType(CustomDatePicker), findsNothing);
  });
  
  testWidgets('BenefitAdminScreen exibe benefícios resgatados na segunda aba', (WidgetTester tester) async {
    // Preparar: Simular verificação de admin
    when(mockRepository.isAdmin()).thenAnswer((_) async => true);
    
    // Renderizar o widget
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: BenefitAdminScreen(),
        ),
      ),
    );
    
    // Aguardar carregamento inicial
    await tester.pumpAndSettle();
    
    // Mudar para a aba "Resgatados"
    await tester.tap(find.text('Resgatados'));
    await tester.pumpAndSettle();
    
    // Verificar se os benefícios resgatados são exibidos
    expect(find.text('CODE123'), findsOneWidget);
    expect(find.text('CODE456'), findsOneWidget);
    expect(find.text('Expirado'), findsOneWidget); // Status do segundo benefício
  });
  
  testWidgets('BenefitAdminScreen permite estender validade de benefício resgatado', (WidgetTester tester) async {
    // Preparar: Simular verificação de admin
    when(mockRepository.isAdmin()).thenAnswer((_) async => true);
    
    // Renderizar o widget
    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp(
          home: BenefitAdminScreen(),
        ),
      ),
    );
    
    // Aguardar carregamento inicial
    await tester.pumpAndSettle();
    
    // Mudar para a aba "Resgatados"
    await tester.tap(find.text('Resgatados'));
    await tester.pumpAndSettle();
    
    // Tocar no primeiro benefício resgatado para selecioná-lo
    await tester.tap(find.text('CODE123').first);
    await tester.pumpAndSettle();
    
    // Encontrar e tocar no botão de estender validade
    await tester.tap(find.byIcon(Icons.update).first);
    await tester.pumpAndSettle();
    
    // Verificar se o DatePicker aparece
    expect(find.byType(CustomDatePicker), findsOneWidget);
    
    // Tocar no botão "OK" para confirmar a nova data
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    
    // Verificar que o DatePicker foi fechado
    expect(find.byType(CustomDatePicker), findsNothing);
  });
} 
