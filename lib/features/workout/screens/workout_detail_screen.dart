import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/components/app_error_widget.dart';
import 'package:ray_club_app/core/components/app_loading.dart';
import 'package:ray_club_app/core/theme/app_colors.dart';
import 'package:ray_club_app/core/theme/app_typography.dart';
import 'package:ray_club_app/features/workout/models/workout_model.dart';
import 'package:ray_club_app/features/workout/viewmodels/workout_view_model.dart';
import 'package:ray_club_app/features/workout/widgets/exercise_list_item.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  const WorkoutDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutViewModelProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: workoutState.maybeWhen(
        loading: () => const AppLoading(),
        error: (message) => AppErrorWidget(
          message: message,
          onRetry: () => Navigator.pop(context),
        ),
        selectedWorkout: (workout, _, __, ___, ____) => Stack(
          children: [
            _buildContent(context, workout, ref),
            _buildActionButtons(context, workout, ref),
          ],
        ),
        orElse: () => const AppLoading(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Workout workout, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, workout, ref),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkoutInfo(context, workout),
                const SizedBox(height: 24),
                _buildDescription(context, workout),
                const SizedBox(height: 24),
                _buildExerciseHeader(context, workout),
              ],
            ),
          ),
        ),
        _buildExerciseList(context, workout),
        SliverToBoxAdapter(
          child: const SizedBox(height: 100), // Espaço para o botão
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Workout workout, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.backgroundDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem de fundo
            workout.imageUrl != null && workout.imageUrl!.isNotEmpty
                ? Image.network(
                    workout.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(color: AppColors.primary),
            // Gradiente sobre a imagem
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Título no topo da imagem
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      workout.type,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.title,
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: AppColors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Função em desenvolvimento')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: AppColors.white),
          onPressed: () {
            Navigator.pushNamed(
              context, 
              '/workout/edit',
              arguments: workout.id,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Workout workout, WidgetRef ref) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context, workout, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Excluir Treino',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Iniciando treino...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Iniciar Treino',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Workout workout, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          'Excluir Treino',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir "${workout.title}"? Esta ação não pode ser desfeita.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Cancelar',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(workoutViewModelProvider.notifier).deleteWorkout(workout.id);
                if (context.mounted) {
                  Navigator.of(context).pop(); // Voltar para a lista
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir treino: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Excluir',
              style: AppTypography.bodyMedium.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutInfo(BuildContext context, Workout workout) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoItem(
          icon: Icons.timer,
          value: '${workout.durationMinutes}',
          label: 'Minutos',
        ),
        _buildInfoItem(
          icon: Icons.fitness_center,
          value: '${workout.exercises.length}',
          label: 'Exercícios',
        ),
        _buildInfoItem(
          icon: Icons.trending_up,
          value: workout.difficulty,
          label: 'Nível',
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.headingSmall.copyWith(color: AppColors.white),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Workout workout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sobre este treino',
          style: AppTypography.headingSmall.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 8),
        Text(
          workout.description,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildExerciseHeader(BuildContext context, Workout workout) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Exercícios',
          style: AppTypography.headingSmall.copyWith(color: AppColors.white),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.timer,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${workout.durationMinutes} min',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(BuildContext context, Workout workout) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= workout.exercises.length) return null;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ExerciseListItem(
              exercise: workout.exercises[index],
              index: index,
              onTap: () {
                // Navegação para tela de detalhes do exercício será implementada depois
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Detalhes do exercício em desenvolvimento'),
                  ),
                );
              },
            ),
          );
        },
        childCount: workout.exercises.length,
      ),
    );
  }
} 