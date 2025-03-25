import 'package:flutter/material.dart';
import 'package:ray_club_app/core/theme/app_colors.dart';
import 'package:ray_club_app/core/theme/app_typography.dart';
import 'package:ray_club_app/features/workout/models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback onTap;

  const WorkoutCard({
    Key? key,
    required this.workout,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildBody(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: workout.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(workout.imageUrl),
                fit: BoxFit.cover,
              )
            : null,
        color: workout.imageUrl.isEmpty ? AppColors.primary : null,
      ),
      child: Stack(
        children: [
          // Gradiente sobre a imagem para legibilidade do texto
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
          // Categoria (tipo) do treino
          Positioned(
            top: 16,
            left: 16,
            child: Container(
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
          ),
          // Título do treino
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Text(
              workout.title,
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Descrição do treino
          Text(
            workout.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // Número de exercícios
          Row(
            children: [
              const Icon(
                Icons.fitness_center,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${workout.exercises.length} ${workout.exercises.length == 1 ? 'exercício' : 'exercícios'}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Duração
          _buildInfoChip(
            icon: Icons.timer,
            text: '${workout.durationMinutes} min',
          ),
          // Dificuldade
          _buildInfoChip(
            icon: Icons.trending_up,
            text: workout.difficulty,
          ),
          // Botão para acessar o treino
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Ver Treino',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundMedium,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
} 