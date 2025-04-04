import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:ray_club_app/features/nutrition/screens/nutrition_screen.dart';
import 'package:ray_club_app/view_models/nutrition_view_model.dart';
import 'package:ray_club_app/models/nutrition_item.dart';

class MockNutritionViewModel extends StateNotifier<NutritionState> with Mock {
  MockNutritionViewModel() : super(const NutritionState());
}

final mockNutritionViewModelProvider = StateNotifierProvider<MockNutritionViewModel, NutritionState>((ref) {
  return MockNutritionViewModel();
});

void main() {
  late MockNutritionViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockNutritionViewModel();
  });

  testWidgets('NutritionScreen exibe carregamento quando isLoading é true', (WidgetTester tester) async {
    mockViewModel.state = const NutritionState(isLoading: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nutritionViewModelProvider.overrideWithProvider(mockNutritionViewModelProvider),
        ],
        child: const MaterialApp(
          home: NutritionScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('NutritionScreen exibe mensagem de erro quando há um errorMessage', (WidgetTester tester) async {
    const errorMessage = 'Erro ao carregar dados';
    mockViewModel.state = const NutritionState(errorMessage: errorMessage);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nutritionViewModelProvider.overrideWithProvider(mockNutritionViewModelProvider),
        ],
        child: const MaterialApp(
          home: NutritionScreen(),
        ),
      ),
    );

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('NutritionScreen exibe tabs e lista de itens quando carregados com sucesso', (WidgetTester tester) async {
    final items = [
      NutritionItem(
        id: '1',
        title: 'Salada Tropical',
        description: 'Uma deliciosa salada tropical',
        category: 'recipe',
        imageUrl: 'https://example.com/salada.png',
        preparationTimeMinutes: 15,
        ingredients: ['Alface', 'Tomate', 'Abacaxi'],
        instructions: ['Lave os vegetais', 'Corte em pedaços', 'Misture tudo'],
        tags: ['Salada', 'Vegano'],
      ),
      NutritionItem(
        id: '2',
        title: 'Dica para Hidratação',
        description: 'Como se manter hidratado durante exercícios',
        category: 'tip',
        imageUrl: 'https://example.com/hidratacao.png',
        preparationTimeMinutes: 5,
        tags: ['Hidratação', 'Saúde'],
        nutritionistTip: 'Beba água regularmente durante o dia.',
      ),
    ];

    mockViewModel.state = NutritionState(
      nutritionItems: items,
      filteredItems: items,
      isLoading: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nutritionViewModelProvider.overrideWithProvider(mockNutritionViewModelProvider),
        ],
        child: const MaterialApp(
          home: NutritionScreen(),
        ),
      ),
    );

    // Verifica se as tabs estão presentes
    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Receitas'), findsOneWidget);
    expect(find.text('Dicas'), findsOneWidget);

    // Verifica se os itens estão sendo exibidos
    expect(find.text('Salada Tropical'), findsOneWidget);
    expect(find.text('Dica para Hidratação'), findsOneWidget);

    // Testa a navegação entre as tabs
    await tester.tap(find.text('Receitas'));
    await tester.pumpAndSettle();

    // Teste mais navegações e comportamentos específicos
    await tester.tap(find.text('Dicas'));
    await tester.pumpAndSettle();
  });
} 