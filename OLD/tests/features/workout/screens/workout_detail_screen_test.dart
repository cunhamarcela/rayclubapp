import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ray_club_app/features/workout/screens/workout_detail_screen.dart';
import 'package:ray_club_app/models/workout.dart';

void main() {
  // Create a sample workout for testing
  final testWorkout = Workout(
    id: '1',
    title: 'Test Workout',
    description: 'This is a test workout description for testing purposes.',
    imageUrl: null, // Use default image
    type: 'Yoga',
    durationMinutes: 45,
    difficulty: 'intermediário',
    equipment: ['mat', 'blocks', 'strap'],
    exercises: {
      'warmup': ['Warm-up Exercise 1', 'Warm-up Exercise 2'],
      'main': ['Main Exercise 1', 'Main Exercise 2', 'Main Exercise 3'],
      'cooldown': ['Cool-down Exercise 1'],
    },
    creatorId: 'test-creator',
    createdAt: DateTime.now(),
  );

  testWidgets('renders workout detail screen correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutDetailScreen(workout: testWorkout),
      ),
    );

    // Verify that the workout title is displayed
    expect(find.text('Test Workout'), findsOneWidget);
    
    // Verify that the workout description is displayed
    expect(find.text('This is a test workout description for testing purposes.'), findsOneWidget);
    
    // Verify that the duration is displayed
    expect(find.text('45 min'), findsOneWidget);
    
    // Verify that the difficulty is displayed
    expect(find.text('intermediário'), findsOneWidget);
    
    // Verify that the type is displayed
    expect(find.text('Yoga'), findsOneWidget);
    
    // Verify that the equipment section is displayed
    expect(find.text('Equipamentos necessários'), findsOneWidget);
    
    // Verify that the equipment items are displayed
    expect(find.text('mat'), findsOneWidget);
    expect(find.text('blocks'), findsOneWidget);
    expect(find.text('strap'), findsOneWidget);
    
    // Verify that the exercise sections are displayed
    expect(find.text('Aquecimento'), findsOneWidget);
    expect(find.text('Parte Principal'), findsOneWidget);
    expect(find.text('Desaquecimento'), findsOneWidget);
    
    // Verify that the start button is displayed
    expect(find.text('INICIAR TREINO'), findsOneWidget);
  });

  testWidgets('tapping start button shows snackbar', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutDetailScreen(workout: testWorkout),
      ),
    );

    // Verify that the start button is displayed
    expect(find.text('INICIAR TREINO'), findsOneWidget);
    
    // Tap the start button
    await tester.tap(find.text('INICIAR TREINO'));
    await tester.pumpAndSettle();
    
    // Verify that the snackbar is displayed
    expect(find.text('Iniciando treino...'), findsOneWidget);
  });

  testWidgets('exercise items are displayed correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: WorkoutDetailScreen(workout: testWorkout),
      ),
    );

    // Verify that all exercise items are displayed
    expect(find.text('Warm-up Exercise 1'), findsOneWidget);
    expect(find.text('Warm-up Exercise 2'), findsOneWidget);
    expect(find.text('Main Exercise 1'), findsOneWidget);
    expect(find.text('Main Exercise 2'), findsOneWidget);
    expect(find.text('Main Exercise 3'), findsOneWidget);
    expect(find.text('Cool-down Exercise 1'), findsOneWidget);
  });
} 