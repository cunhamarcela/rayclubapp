// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/challenge.dart';

class ChallengeProgressCard extends StatelessWidget {
  final Challenge challenge;
  final double progress;
  final bool isActive;

  const ChallengeProgressCard({
    required this.challenge,
    required this.progress,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcular a porcentagem de progresso (0.0 - 1.0)
    final progressPercentage = progress.clamp(0.0, 1.0);
    
    // Converter para mostrar como porcentagem
    final progressText = '${(progressPercentage * 100).toInt()}%';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            challenge.isOfficial ? AppColors.primary : AppColors.accent,
            challenge.isOfficial ? AppColors.primary.withOpacity(0.8) : AppColors.accent.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (challenge.isOfficial ? AppColors.primary : AppColors.accent).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu Progresso',
            style: AppTypography.headingSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    minHeight: 12,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                progressText,
                style: AppTypography.headingSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusBadge(),
              if (isActive)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Ação para fazer check-in ou ver detalhes do progresso
                    // Esta função seria definida pelo componente pai
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: challenge.isOfficial ? AppColors.primary : AppColors.accent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: challenge.isOfficial ? AppColors.primary : AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      const Text('Ver Detalhes'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = isActive
        ? 'Em Andamento'
        : 'Encerrado';
    
    final icon = isActive
        ? Icons.directions_run
        : Icons.flag;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 