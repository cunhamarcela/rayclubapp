import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/components/app_error_widget.dart';
import 'package:ray_club_app/core/components/app_loading.dart';
import 'package:ray_club_app/core/theme/app_colors.dart';
import 'package:ray_club_app/core/theme/app_typography.dart';
import 'package:ray_club_app/features/workout/models/workout_model.dart';
import 'package:ray_club_app/features/workout/screens/workout_detail_screen.dart';
import 'package:ray_club_app/features/workout/viewmodels/states/workout_state.dart';
import 'package:ray_club_app/features/workout/viewmodels/workout_view_model.dart';
import 'package:ray_club_app/features/workout/widgets/workout_card.dart';
import 'package:ray_club_app/features/workout/widgets/workout_filter_bar.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutViewModelProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Treinos', style: AppTypography.headingMedium),
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(workoutViewModelProvider.notifier).loadWorkouts();
            },
          ),
        ],
      ),
      body: _buildBody(context, workoutState, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/workout/new');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WorkoutState state, WidgetRef ref) {
    return state.maybeWhen(
      initial: () => const AppLoading(),
      loading: () => const AppLoading(),
      error: (message) => AppErrorWidget(
        message: message,
        onRetry: () => ref.read(workoutViewModelProvider.notifier).loadWorkouts(),
      ),
      orElse: () => _buildContent(context, state, ref),
    );
  }

  Widget _buildContent(BuildContext context, WorkoutState state, WidgetRef ref) {
    final workouts = state.currentWorkouts;
    final viewModel = ref.read(workoutViewModelProvider.notifier);
    
    if (workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 64,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum treino encontrado',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 24),
            if (state.maybeWhen(
              loaded: (_, __, ___, filter) => filter != const WorkoutFilter(),
              selectedWorkout: (_, __, ___, ____, filter) => filter != const WorkoutFilter(),
              orElse: () => false,
            ))
              ElevatedButton(
                onPressed: () => viewModel.resetFilters(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Limpar filtros',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      children: [
        WorkoutFilterBar(
          categories: state.maybeWhen(
            loaded: (_, __, categories, ___) => categories,
            selectedWorkout: (_, __, ___, categories, ____) => categories,
            orElse: () => [],
          ),
          currentFilter: state.maybeWhen(
            loaded: (_, __, ___, filter) => filter,
            selectedWorkout: (_, __, ___, ____, filter) => filter,
            orElse: () => const WorkoutFilter(),
          ),
          onCategorySelected: (category) => viewModel.filterByCategory(category),
          onDurationSelected: (minutes) => viewModel.filterByDuration(minutes),
          onDifficultySelected: (difficulty) => viewModel.filterByDifficulty(difficulty),
          onResetFilters: () => viewModel.resetFilters(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return WorkoutCard(
                  workout: workout,
                  onTap: () => _navigateToDetail(context, workout, ref),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, Workout workout, WidgetRef ref) {
    ref.read(workoutViewModelProvider.notifier).selectWorkout(workout.id);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutDetailScreen(),
      ),
    ).then((_) {
      // Quando voltar da tela de detalhes, limpar a seleção
      ref.read(workoutViewModelProvider.notifier).clearSelection();
    });
  }
} 