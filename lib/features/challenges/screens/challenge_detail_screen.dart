import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_textures.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/providers/providers.dart';
import '../../auth/repositories/auth_repository.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import '../services/challenge_image_service.dart';
import '../widgets/challenge_leaderboard.dart';
import '../widgets/challenge_progress_card.dart';

// Adicionando o provider para o usuário atual
final currentUserProvider = FutureProvider<supabase.User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
});

class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;

  const ChallengeDetailScreen({
    required this.challengeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeAsync = ref.watch(challengeByIdProvider(challengeId));
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser.value?.id;
    final imageService = ref.watch(challengeImageServiceProvider);

    return Scaffold(
      body: challengeAsync.when(
        data: (challenge) => _buildContent(context, ref, challenge, userId, imageService),
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => EmptyState(
            message: 'Não foi possível carregar os detalhes do desafio.',
            icon: Icons.error_outline,
            actionLabel: 'Tentar novamente',
            onAction: () => ref.refresh(challengeByIdProvider(challengeId)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, 
    WidgetRef ref, 
    Challenge challenge, 
    String? userId,
    ChallengeImageService imageService
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final now = DateTime.now();
    final isActive = challenge.endDate.isAfter(now);
    final daysLeft = challenge.endDate.difference(now).inDays;
    final progressAsync = userId != null 
        ? ref.watch(userChallengeProgressProvider(UserChallengeProgressParams(
            userId: userId, 
            challengeId: challengeId,
          )))
        : const AsyncValue.data(0.0);
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Imagem do desafio com gradiente
                imageService.buildChallengeImageWithGradient(
                  challenge,
                  height: 200,
                  child: Container(), // Container vazio para o gradiente
                ),
                // Badge de status
                Positioned(
                  top: 70,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.secondary : AppColors.error,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isActive 
                            ? AppColors.secondary.withOpacity(0.3) 
                            : AppColors.error.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? Icons.timer : Icons.timer_off,
                          size: 14,
                          color: isActive ? AppColors.textDark : Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isActive
                              ? '$daysLeft dias'
                              : 'Encerrado',
                          style: AppTypography.bodySmall.copyWith(
                            color: isActive ? AppColors.textDark : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Badge oficial ou badge de participantes
                Positioned(
                  top: 70,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: challenge.isOfficial ? AppColors.primary : AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (challenge.isOfficial ? AppColors.primary : AppColors.accent).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          challenge.isOfficial ? Icons.verified : Icons.people,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          challenge.isOfficial 
                              ? 'Oficial' 
                              : '${challenge.participants.length} participantes',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                challenge.title,
                style: AppTypography.headingMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
        SliverToBoxAdapter(
          child: AppTextures.addWaveTexture(
            _buildDetailContent(context, ref, challenge, userId, progressAsync, dateFormat, isActive),
            opacity: 0.05,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailContent(
    BuildContext context, 
    WidgetRef ref, 
    Challenge challenge, 
    String? userId,
    AsyncValue<double> progressAsync,
    DateFormat dateFormat,
    bool isActive,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cartão de progresso do usuário (se estiver logado)
          if (userId != null)
            progressAsync.when(
              data: (progress) => ChallengeProgressCard(
                challenge: challenge,
                progress: progress,
                isActive: isActive,
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: LoadingIndicator(size: 24),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
          const SizedBox(height: 16),
          
          // Descrição
          Text(
            'Descrição',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Período
          Text(
            'Período',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Início: ${dateFormat.format(challenge.startDate)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fim: ${dateFormat.format(challenge.endDate)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Regras
          Text(
            'Regras',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pontos por check-in diário: ${challenge.points}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  challenge.isOfficial 
                      ? 'Bônus de 50 pontos a cada 5 dias consecutivos!' 
                      : 'Complete os requisitos para acumular pontos.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (challenge.requirements != null && challenge.requirements!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Requisitos:',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...challenge.requirements!.map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            req,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Ranking
          Text(
            'Ranking',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ChallengeLeaderboard(challengeId: challengeId),
        ],
      ),
    );
  }
}