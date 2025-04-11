// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

// Project imports:
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textures.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../auth/repositories/auth_repository.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';
import '../widgets/challenge_card.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser.value?.id;
    
    return Scaffold(
      body: SafeArea(
        child: AppTextures.addWaveTexture(
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Text(
                  'Desafios',
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // TODO: Navegar para tela de criar desafio
                    },
                    tooltip: 'Criar desafio',
                  ),
                ],
              ),
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                ref.refresh(officialChallengesProvider);
                if (userId != null) {
                  ref.refresh(userChallengesProvider(userId));
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Desafios Oficiais
                      Text(
                        'Desafios Oficiais',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildOfficialChallenges(context, ref),
                      
                      const SizedBox(height: 32),
                      
                      // Desafios do Usuário (se estiver logado)
                      if (userId != null) ...[
                        Text(
                          'Meus Desafios',
                          style: AppTypography.headingMedium.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildUserChallenges(context, ref, userId),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Botão para criar novo desafio
                      if (userId != null)
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navegar para tela de criar desafio
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Criar Novo Desafio'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          opacity: 0.05,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildOfficialChallenges(BuildContext context, WidgetRef ref) {
    final officialChallengesAsync = ref.watch(officialChallengesProvider);
    
    return officialChallengesAsync.when(
      data: (challenges) {
        if (challenges.isEmpty) {
          return const EmptyState(
            icon: Icons.emoji_events_outlined,
            message: 'Não há desafios oficiais disponíveis no momento.',
          );
        }
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return ChallengeCard(
              challenge: challenge,
              onTap: () => _navigateToChallengeDetail(context, challenge.id),
            );
          },
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
        message: 'Não foi possível carregar os desafios oficiais.',
        onRetry: () => ref.refresh(officialChallengesProvider),
        retryText: 'Tentar novamente',
      ),
    );
  }

  Widget _buildUserChallenges(BuildContext context, WidgetRef ref, String userId) {
    final userChallengesAsync = ref.watch(userChallengesProvider(userId));
    
    return userChallengesAsync.when(
      data: (challenges) {
        if (challenges.isEmpty) {
          return EmptyState(
            icon: Icons.sports_outlined,
            message: 'Você ainda não participa de nenhum desafio.',
            onRetry: () {
              // TODO: Navegar para tela de criar desafio
            },
            retryText: 'Criar Desafio',
          );
        }
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return ChallengeCard(
              challenge: challenge,
              onTap: () => _navigateToChallengeDetail(context, challenge.id),
            );
          },
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
        message: 'Não foi possível carregar seus desafios.',
        onRetry: () => ref.refresh(userChallengesProvider(userId)),
        retryText: 'Tentar novamente',
      ),
    );
  }

  void _navigateToChallengeDetail(BuildContext context, String challengeId) {
    context.router.push(RealtimeChallengeDetailRoute(challengeId: challengeId));
  }
} 