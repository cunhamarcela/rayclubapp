// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/challenge_progress.dart';
import '../providers/challenge_provider.dart';

class ChallengeLeaderboard extends ConsumerWidget {
  final String challengeId;

  const ChallengeLeaderboard({
    required this.challengeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(challengeProgressProvider(challengeId));

    return progressAsync.when(
      data: (progressList) {
        if (progressList.isEmpty) {
          return EmptyState(
            icon: Icons.emoji_events_outlined,
            message: 'Ainda não há participantes neste desafio.',
          );
        }

        // Ordenar por pontos (do maior para o menor)
        final sortedList = [...progressList]
          ..sort((a, b) => b.points.compareTo(a.points));

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Cabeçalho do Ranking
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Pos.',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Participante',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Pontos',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de participantes
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedList.length > 10 ? 10 : sortedList.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final progress = sortedList[index];
                  return _buildParticipantRow(context, progress, index + 1);
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: LoadingIndicator(),
        ),
      ),
      error: (error, stackTrace) => EmptyState(
        icon: Icons.error_outline,
        message: 'Não foi possível carregar o ranking dos participantes.',
        onAction: () => ref.refresh(challengeProgressProvider(challengeId)),
        actionLabel: 'Tentar novamente',
      ),
    );
  }

  Widget _buildParticipantRow(BuildContext context, ChallengeProgress progress, int position) {
    Color positionColor;
    IconData? positionIcon;

    // Definir cor e ícone com base na posição
    if (position == 1) {
      positionColor = const Color(0xFFFFD700); // Ouro
      positionIcon = Icons.emoji_events;
    } else if (position == 2) {
      positionColor = const Color(0xFFC0C0C0); // Prata
      positionIcon = Icons.emoji_events;
    } else if (position == 3) {
      positionColor = const Color(0xFFCD7F32); // Bronze
      positionIcon = Icons.emoji_events;
    } else {
      positionColor = AppColors.textSecondary;
      positionIcon = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Posição
          Expanded(
            flex: 1,
            child: positionIcon != null
                ? Icon(
                    positionIcon,
                    color: positionColor,
                    size: 24,
                  )
                : Text(
                    '$position',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: positionColor,
                    ),
                  ),
          ),
          // Participante
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    image: progress.userPhotoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(progress.userPhotoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: progress.userPhotoUrl == null
                      ? const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 18,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    progress.userName,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: position <= 3 ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Pontos
          Expanded(
            flex: 1,
            child: Text(
              '${progress.points}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: position <= 3 ? AppColors.primary : AppColors.textDark,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
} 