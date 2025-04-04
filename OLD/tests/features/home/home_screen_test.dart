import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ray_club_app/core/providers/providers.dart';
import 'package:ray_club_app/features/home/screens/home_screen.dart';
import 'package:ray_club_app/view_models/auth/auth_view_model.dart';
import 'package:ray_club_app/view_models/auth/states/auth_state.dart';
import 'package:ray_club_app/view_models/home/home_view_model.dart';
import 'package:ray_club_app/view_models/home/states/home_state.dart';
import 'package:ray_club_app/features/home/widgets/challenge/challenge_card.dart';
import 'package:ray_club_app/features/home/widgets/workout/workout_card.dart';

// Mock do AuthViewModel
class MockAuthViewModel extends StateNotifier<AuthState> {
  MockAuthViewModel() : super(const AuthState.unauthenticated());
}

// Mock do HomeViewModel
class MockHomeViewModel extends StateNotifier<HomeState> {
  MockHomeViewModel() : super(HomeState.initial());

  void setLoaded() {
    state = HomeState.loaded(
      challenges: [
        {'id': '1', 'title': 'Desafio Teste', 'description': 'Descrição do desafio'},
        {'id': '2', 'title': 'Desafio Teste 2', 'description': 'Outra descrição'},
      ],
      workouts: [
        {'id': '1', 'name': 'Treino Teste', 'duration': '30 min', 'level': 'Iniciante'},
        {'id': '2', 'name': 'Treino Teste 2', 'duration': '45 min', 'level': 'Intermediário'},
      ],
    );
  }

  void setError() {
    state = HomeState.error('Erro de teste');
  }

  void setLoading() {
    state = HomeState.loading();
  }
}

void main() {
  late MockHomeViewModel mockHomeViewModel;
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    mockHomeViewModel = MockHomeViewModel();
    mockAuthViewModel = MockAuthViewModel();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        homeViewModelProvider.overrideWithValue(mockHomeViewModel),
        authViewModelProvider.overrideWithValue(mockAuthViewModel),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('deve mostrar o título na AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Ray Club'), findsOneWidget);
    });

    testWidgets('deve mostrar tela de carregamento quando isLoading é true', (WidgetTester tester) async {
      mockHomeViewModel.setLoading();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve mostrar mensagem de erro quando há erro', (WidgetTester tester) async {
      mockHomeViewModel.setError();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.textContaining('Erro'), findsOneWidget);
    });

    testWidgets('deve mostrar desafios e treinos quando carregado', (WidgetTester tester) async {
      mockHomeViewModel.setLoaded();
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.pump();
      
      // Verifica os títulos das seções
      expect(find.text('Desafios Ativos'), findsOneWidget);
      expect(find.text('Sugestões para você'), findsOneWidget);
      
      // Verifica se os cards estão sendo exibidos
      expect(find.byType(ChallengeCard), findsWidgets);
      expect(find.byType(WorkoutCard), findsWidgets);
    });

    testWidgets('deve mostrar o banner de boas-vindas', (WidgetTester tester) async {
      mockHomeViewModel.setLoaded();
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Bem-vinda ao Ray Club'), findsOneWidget);
      expect(find.text('Sua jornada fitness personalizada'), findsOneWidget);
    });

    testWidgets('deve mostrar FAB para registrar treino', (WidgetTester tester) async {
      mockHomeViewModel.setLoaded();
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Registrar treino'), findsOneWidget);
    });
  });
} 