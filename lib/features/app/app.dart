import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/theme/app_theme.dart';
import 'package:ray_club_app/features/auth/screens/auth_screen.dart';
import 'package:ray_club_app/features/auth/viewmodels/auth_view_model.dart';
import 'package:ray_club_app/features/home/screens/home_screen.dart';
import 'package:ray_club_app/features/workout/screens/workout_form_screen.dart';
import 'package:ray_club_app/features/workout/screens/workout_list_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authViewModelProvider);
    final appTheme = AppTheme.darkTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ray Club',
      theme: appTheme,
      home: userState.maybeWhen(
        authenticated: (_) => const HomeScreen(),
        orElse: () => const AuthScreen(),
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/workouts': (context) => const WorkoutListScreen(),
        '/workout/new': (context) => const WorkoutFormScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/workout/edit') {
          final workoutId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => WorkoutFormScreen(workoutId: workoutId),
          );
        }
        return null;
      },
    );
  }
} 