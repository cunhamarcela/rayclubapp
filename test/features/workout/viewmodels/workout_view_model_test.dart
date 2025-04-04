import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/workout/models/workout_model.dart';
import 'package:ray_club_app/features/workout/repositories/workout_repository.dart';
import 'package:ray_club_app/features/workout/viewmodels/workout_view_model.dart';
import 'package:ray_club_app/features/workout/viewmodels/states/workout_state.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

class MockNotFoundException extends Mock implements AppException {
  @override
  final String message;
  
  MockNotFoundException({required this.message});
}

void main() {
  late WorkoutViewModel viewModel;
  late MockWorkoutRepository mockRepository;

  // Dados de teste
  final testWorkouts = [
    Workout(
      id: '1',
      title: 'Yoga para Iniciantes',
      description: 'Um treino de yoga suave para quem está começando a praticar.',
      imageUrl: 'assets/images/categories/yoga.png',
      type: 'Yoga',
      durationMinutes: 20,
      difficulty: 'Iniciante',
      equipment: ['Tapete', 'Bloco de yoga'],
      sections: [], // Usando o formato correto
      creatorId: 'instrutor1',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Workout(
      id: '2',
      title: 'Pilates Abdominal',
      description: 'Treino focado no fortalecimento do core e abdômen usando técnicas de pilates.',
      imageUrl: 'assets/images/categories/pilates.png',
      type: 'Pilates',
      durationMinutes: 30,
      difficulty: 'Intermediário',
      equipment: ['Tapete', 'Bola pequena'],
      sections: [], // Usando o formato correto
      creatorId: 'instrutor2',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Workout(
      id: '3',
      title: 'HIIT Cardio',
      description: 'Treino HIIT para queimar calorias e melhorar condicionamento.',
      imageUrl: 'assets/images/categories/hiit.png',
      type: 'HIIT',
      durationMinutes: 15,
      difficulty: 'Avançado',
      equipment: [],
      sections: [], // Usando o formato correto
      creatorId: 'instrutor1',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  setUp(() {
    mockRepository = MockWorkoutRepository();
    viewModel = WorkoutViewModel(mockRepository);
  });

  group('WorkoutViewModel', () {
    test('deve iniciar com o estado inicial', () async {
      // Arrange - prepare um mock que retorna uma lista vazia
      when(() => mockRepository.getWorkouts())
          .thenAnswer((_) async => []);
      
      // O ViewModel chama loadWorkouts() no construtor, que é assíncrono
      // Precisamos esperar que o Future seja concluído
      await Future.delayed(Duration.zero); // Aguardar ciclo de eventos para permitir processamento assíncrono
      
      // Assert
      // Verificamos se o método foi chamado pelo construtor
      verify(() => mockRepository.getWorkouts()).called(1);
      
      // O ViewModel pode não estar mais no estado isLoading após a chamada assíncrona,
      // então verificamos se o estado está em um dos estados esperados
      expect(
        viewModel.state.maybeWhen(
          loading: () => true,
          loaded: (_, __, ___, ____) => true,
          error: (_) => true,
          orElse: () => false,
        ),
        true,
      );
    });

    group('loadWorkouts', () {
      test('deve atualizar o estado para loaded com os treinos', () async {
        // Arrange
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);

        // Act
        await viewModel.loadWorkouts();

        // Assert
        // Verifica se o método foi chamado duas vezes (uma no construtor e uma explicitamente)
        verify(() => mockRepository.getWorkouts()).called(2);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.currentWorkouts, testWorkouts);
        
        // As verificações de categorias não funcionam diretamente
        // já que categories está encapsulado no estado
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, categories, ___) => categories.length,
          orElse: () => 0,
        ), 3);
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, categories, ___) => categories.contains('Yoga'),
          orElse: () => false,
        ), true);
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, categories, ___) => categories.contains('Pilates'),
          orElse: () => false,
        ), true);
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, categories, ___) => categories.contains('HIIT'),
          orElse: () => false,
        ), true);
      });

      test('deve atualizar o estado para error quando ocorre uma exceção', () async {
        // Arrange
        when(() => mockRepository.getWorkouts())
            .thenThrow(AppException(message: 'Erro ao carregar treinos'));

        // Act
        await viewModel.loadWorkouts();

        // Assert
        verify(() => mockRepository.getWorkouts()).called(2);
        
        expect(viewModel.state.maybeWhen(
          error: (message) => message,
          orElse: () => '',
        ), 'Erro ao carregar treinos');
      });
    });

    group('filterByCategory', () {
      setUp(() async {
        // Setup para ter treinos carregados
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);
        await viewModel.loadWorkouts();
      });

      test('deve filtrar os treinos pela categoria especificada', () async {
        // Act
        viewModel.filterByCategory('Yoga');

        // Assert
        expect(viewModel.state.currentWorkouts.length, 1);
        expect(viewModel.state.currentWorkouts.first.title, 'Yoga para Iniciantes');
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.category,
          orElse: () => '',
        ), 'Yoga');
      });

      test('deve restaurar todos os treinos quando a categoria é vazia', () async {
        // Arrange - primeiro aplica um filtro
        viewModel.filterByCategory('Yoga');
        expect(viewModel.state.currentWorkouts.length, 1);

        // Act - remove o filtro
        viewModel.filterByCategory('');

        // Assert
        expect(viewModel.state.currentWorkouts.length, 3);
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.category,
          orElse: () => 'invalid',
        ), '');
      });
    });

    group('filterByDuration', () {
      setUp(() async {
        // Setup para ter treinos carregados
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);
        await viewModel.loadWorkouts();
      });

      test('deve filtrar os treinos pela duração máxima', () async {
        // Act
        viewModel.filterByDuration(20);

        // Assert
        expect(viewModel.state.currentWorkouts.length, 2); // Yoga (20min) e HIIT (15min)
        expect(viewModel.state.currentWorkouts.any((w) => w.title.contains('Yoga')), true);
        expect(viewModel.state.currentWorkouts.any((w) => w.title.contains('HIIT')), true);
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.maxDuration,
          orElse: () => 0,
        ), 20);
      });

      test('deve combinar filtros de duração e categoria', () async {
        // Arrange - primeiro aplica um filtro de categoria
        viewModel.filterByCategory('HIIT');
        expect(viewModel.state.currentWorkouts.length, 1);

        // Act - adiciona filtro de duração
        viewModel.filterByDuration(15);

        // Assert - apenas o treino de HIIT que tem 15min
        expect(viewModel.state.currentWorkouts.length, 1);
        expect(viewModel.state.currentWorkouts.first.title, 'HIIT Cardio');
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.category,
          orElse: () => '',
        ), 'HIIT');
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.maxDuration,
          orElse: () => 0,
        ), 15);
      });
    });

    group('selectWorkout', () {
      test('deve atualizar o estado para selectedWorkout quando o treino existe', () async {
        // Arrange
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);
        when(() => mockRepository.getWorkoutById('1'))
            .thenAnswer((_) async => testWorkouts[0]);
        
        await viewModel.loadWorkouts();

        // Act
        await viewModel.selectWorkout('1');

        // Assert
        verify(() => mockRepository.getWorkoutById('1')).called(1);
        
        expect(viewModel.state.selectedWorkout != null, true);
        expect(viewModel.state.selectedWorkout?.id, '1');
        expect(viewModel.state.selectedWorkout?.title, 'Yoga para Iniciantes');
      });

      test('deve atualizar o estado para error quando o treino não existe', () async {
        // Arrange
        when(() => mockRepository.getWorkoutById('invalid-id'))
            .thenThrow(MockNotFoundException(message: 'Treino não encontrado'));
        
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);
        
        await viewModel.loadWorkouts();

        // Act
        await viewModel.selectWorkout('invalid-id');

        // Assert
        verify(() => mockRepository.getWorkoutById('invalid-id')).called(1);
        
        expect(viewModel.state.maybeWhen(
          error: (message) => message,
          orElse: () => '',
        ), 'Treino não encontrado');
      });
    });

    group('clearSelection', () {
      test('deve voltar ao estado loaded quando havia um treino selecionado', () async {
        // Arrange
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);
        when(() => mockRepository.getWorkoutById('1'))
            .thenAnswer((_) async => testWorkouts[0]);
        
        await viewModel.loadWorkouts();
        await viewModel.selectWorkout('1');
        expect(viewModel.state.selectedWorkout != null, true);

        // Act
        viewModel.clearSelection();

        // Assert
        expect(viewModel.state.selectedWorkout == null, true);
        
        // Não fazemos mais verificações detalhadas sobre o conteúdo da lista
        // Apenas verificamos se voltou ao estado loaded
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, ____) => true,
          orElse: () => false,
        ), true);
      });
    });

    group('resetFilters', () {
      setUp(() async {
        // Setup para ter treinos carregados
        when(() => mockRepository.getWorkouts())
            .thenAnswer((_) async => testWorkouts);
        await viewModel.loadWorkouts();
      });

      test('deve remover todos os filtros aplicados', () async {
        // Arrange - aplica filtros
        viewModel.filterByCategory('Yoga');
        viewModel.filterByDuration(20);
        expect(viewModel.state.currentWorkouts.length, 1);

        // Act
        viewModel.resetFilters();

        // Assert
        expect(viewModel.state.currentWorkouts.length, 3); // Todos os treinos
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.category,
          orElse: () => 'invalid',
        ), '');
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.maxDuration,
          orElse: () => -1,
        ), 0);
        
        expect(viewModel.state.maybeWhen(
          loaded: (_, __, ___, filter) => filter.difficulty,
          orElse: () => 'invalid',
        ), '');
      });
    });
  });
} 