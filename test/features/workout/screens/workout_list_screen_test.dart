// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:ray_club_app/features/workout/models/workout_model.dart';
import 'package:ray_club_app/features/workout/screens/workout_list_screen.dart';
import 'package:ray_club_app/features/workout/viewmodels/states/workout_state.dart';
import 'package:ray_club_app/features/workout/viewmodels/workout_view_model.dart';

class MockWorkoutViewModel extends Mock implements WorkoutViewModel {}

void main() {
  late MockWorkoutViewModel mockViewModel;
  late WorkoutState workoutState;

  setUp(() {
    mockViewModel = MockWorkoutViewModel();
    
    // Create a sample workout
    final sampleWorkout = Workout(
      id: '1',
      title: 'Sample Workout',
      description: 'This is a sample workout for testing',
      type: 'Yoga',
      durationMinutes: 30,
      difficulty: 'intermediário',
      equipment: ['mat', 'blocks'],
      exercises: {
        'warmup': ['Stretch 1', 'Stretch 2'],
        'main': ['Pose 1', 'Pose 2', 'Pose 3'],
        'cooldown': ['Cool down 1']
      },
      creatorId: 'user1',
      createdAt: DateTime.now(),
    );
    
    // Create a list of workouts for the state
    workoutState = WorkoutState.loaded(
      workouts: [sampleWorkout],
      filteredWorkouts: [sampleWorkout],
      categories: ['Yoga'],
      filter: const WorkoutFilter(),
    );
  });

  testWidgets('renders workout list when data is available', (WidgetTester tester) async {
    // Override the provider for testing
    final container = ProviderContainer(
      overrides: [
        workoutViewModelProvider.overrideWith((_) => mockViewModel),
      ],
    );
    
    // Mock the state to be returned
    when(() => mockViewModel.loadWorkouts()).thenAnswer((_) async {});
    when(() => mockViewModel.state).thenReturn(workoutState);
    
    // Build our app and trigger a frame
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: WorkoutListScreen(),
        ),
      ),
    );
    
    // Verify that the title is displayed
    expect(find.text('Treinos'), findsOneWidget);
    
    // Verify that the category section is displayed
    expect(find.text('Escolha uma categoria'), findsOneWidget);
    
    // Verify that the duration filter is displayed
    expect(find.text('Filtrar por tempo'), findsOneWidget);
    
    // Verify that the workout card is displayed
    expect(find.text('Sample Workout'), findsOneWidget);
    expect(find.text('This is a sample workout for testing'), findsOneWidget);
    
    // Clean up the ProviderContainer
    container.dispose();
  });

  testWidgets('shows loading indicator when data is loading', (WidgetTester tester) async {
    // Override the provider for testing with loading state
    final loadingState = WorkoutState.loading();
    
    final container = ProviderContainer(
      overrides: [
        workoutViewModelProvider.overrideWith((_) => mockViewModel),
      ],
    );
    
    when(() => mockViewModel.state).thenReturn(loadingState);
    
    // Build our app and trigger a frame
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: WorkoutListScreen(),
        ),
      ),
    );
    
    // Verify that the loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Clean up the ProviderContainer
    container.dispose();
  });

  testWidgets('shows error message when error occurs', (WidgetTester tester) async {
    // Override the provider for testing with error state
    final errorState = WorkoutState.error('Failed to load workouts');
    
    final container = ProviderContainer(
      overrides: [
        workoutViewModelProvider.overrideWith((_) => mockViewModel),
      ],
    );
    
    when(() => mockViewModel.state).thenReturn(errorState);
    
    // Build our app and trigger a frame
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: WorkoutListScreen(),
        ),
      ),
    );
    
    // Verify that the error message is displayed
    expect(find.text('Failed to load workouts'), findsOneWidget);
    
    // Clean up the ProviderContainer
    container.dispose();
  });
} 
