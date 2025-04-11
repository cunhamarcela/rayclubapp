import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_textures.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/repositories/auth_repository.dart';
import '../models/challenge.dart';
import '../models/challenge_progress.dart';
import '../providers/challenge_provider.dart';
import '../services/challenge_image_service.dart';
import '../widgets/challenge_leaderboard.dart';
import '../widgets/challenge_progress_card.dart';
import '../viewmodels/challenge_view_model.dart';

final realtimeProgressProvider = StreamProvider.family<List<ChallengeProgress>, String>((ref, challengeId) {
  final repository = ref.watch(challengeRepositoryProvider);
  return repository.watchChallengeParticipants(challengeId);
});

@RoutePage()
class RealtimeChallengeDetailScreen extends ConsumerStatefulWidget {
  final String challengeId;

  const RealtimeChallengeDetailScreen({
    required this.challengeId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RealtimeChallengeDetailScreen> createState() => _RealtimeChallengeDetailScreenState();
}

class _RealtimeChallengeDetailScreenState extends ConsumerState<RealtimeChallengeDetailScreen> {
  bool _isCheckingIn = false;
  bool _hasCheckedInToday = false;
  int _consecutiveDays = 0;
  bool _loadingStats = true;

  @override
  void initState() {
    super.initState();
    // Load challenge data and check if user has already checked in today
    Future.microtask(() => _loadChallengeStats());
  }

  Future<void> _loadChallengeStats() async {
    setState(() {
      _loadingStats = true;
    });

    try {
      final currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
      if (currentUser != null) {
        final repository = ref.read(challengeRepositoryProvider);
        
        // Check if user has already checked in today
        final hasCheckedIn = await repository.hasCheckedInOnDate(
          currentUser.id, 
          widget.challengeId, 
          DateTime.now()
        );
        
        // Get consecutive days
        final consecutiveDays = await repository.getConsecutiveDaysCount(
          currentUser.id, 
          widget.challengeId
        );
        
        if (mounted) {
          setState(() {
            _hasCheckedInToday = hasCheckedIn;
            _consecutiveDays = consecutiveDays;
            _loadingStats = false;
          });
        }
      } else {
        setState(() {
          _loadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingStats = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar estatísticas: $e')),
        );
      }
    }
  }

  Future<void> _recordCheckIn(Challenge challenge) async {
    final currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('É necessário estar logado para fazer check-in')),
      );
      return;
    }

    setState(() {
      _isCheckingIn = true;
    });

    try {
      final repository = ref.read(challengeRepositoryProvider);
      final today = DateTime.now();
      
      // Record check-in with points
      await repository.recordChallengeCheckIn(
        currentUser.id,
        widget.challengeId,
        today,
        challenge.points,
        currentUser.userMetadata?['name'] ?? 'Usuário',
        currentUser.userMetadata?['avatar_url'],
      );
      
      // If user has consecutive days, add bonus points
      if (_consecutiveDays > 0 && _consecutiveDays % 3 == 0) {
        // Every 3 consecutive days, add bonus points
        final bonusPoints = challenge.points;
        await repository.addBonusPoints(
          currentUser.id,
          widget.challengeId,
          bonusPoints,
          'Bônus por $_consecutiveDays dias consecutivos',
          currentUser.userMetadata?['name'] ?? 'Usuário',
          currentUser.userMetadata?['avatar_url'],
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Parabéns! Você ganhou $bonusPoints pontos de bônus por $_consecutiveDays dias consecutivos!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
      
      // Refresh stats
      await _loadChallengeStats();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check-in registrado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar check-in: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengeAsync = ref.watch(challengeByIdProvider(widget.challengeId));
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.id;
    final imageService = ref.watch(challengeImageServiceProvider);

    return Scaffold(
      body: challengeAsync.when(
        data: (challenge) => _buildContent(context, ref, challenge, userId, imageService),
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => EmptyState(
          message: 'Não foi possível carregar os detalhes do desafio.',
          icon: Icons.error_outline,
          actionLabel: 'Tentar novamente',
          onAction: () => ref.refresh(challengeByIdProvider(widget.challengeId)),
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
    
    // Usar o provider em tempo real para o progresso
    final realtimeProgressAsync = ref.watch(realtimeProgressProvider(widget.challengeId));
    
    // Obter o progresso do usuário no desafio
    final progressAsync = userId != null 
        ? ref.watch(userChallengeProgressProvider(UserChallengeProgressParams(
            userId: userId, 
            challengeId: widget.challengeId,
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
                  child: FadeIn(
                    duration: const Duration(milliseconds: 500),
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
                ),
                // Badge oficial ou badge de participantes
                Positioned(
                  top: 70,
                  left: 16,
                  child: FadeIn(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cartão de progresso do usuário (se estiver logado)
                  if (userId != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: progressAsync.when(
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
                    ),
                    
                  const SizedBox(height: 16),
                  
                  // Status de check-in diário e contador de dias consecutivos
                  if (userId != null && isActive)
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cream,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _hasCheckedInToday ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: _hasCheckedInToday ? AppColors.success : AppColors.textLight,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _hasCheckedInToday
                                      ? 'Check-in de hoje realizado!'
                                      : 'Faça seu check-in diário',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _hasCheckedInToday ? AppColors.success : AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: AppColors.accent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    _loadingStats 
                                      ? const SizedBox(
                                          width: 16, 
                                          height: 16, 
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                                          ),
                                        )
                                      : Text(
                                          '$_consecutiveDays dias consecutivos',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: _hasCheckedInToday || _isCheckingIn || !isActive
                                      ? null
                                      : () => _recordCheckIn(challenge),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: _isCheckingIn
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Check-in'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                  const SizedBox(height: 16),
                  
                  // Descrição
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Descrição',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                      child: Text(
                        challenge.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Detalhes
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      'Detalhes',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 350),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                          _buildDetailRow(
                            'Início',
                            dateFormat.format(challenge.startDate),
                            Icons.calendar_today,
                          ),
                          const Divider(),
                          _buildDetailRow(
                            'Término',
                            dateFormat.format(challenge.endDate),
                            Icons.event,
                          ),
                          const Divider(),
                          _buildDetailRow(
                            'Pontos por check-in',
                            '${challenge.points}',
                            Icons.star,
                          ),
                          const Divider(),
                          _buildDetailRow(
                            'Tipo',
                            challenge.type.toUpperCase(),
                            Icons.category,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ranking em tempo real
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'Ranking em Tempo Real',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 450),
                    child: realtimeProgressAsync.when(
                      data: (progressList) {
                        if (progressList.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
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
                            child: const Center(
                              child: Text('Ainda não há participantes neste desafio.'),
                            ),
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
                                itemCount: sortedList.length > 5 ? 5 : sortedList.length,
                                separatorBuilder: (context, index) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final progress = sortedList[index];
                                  final isCurrentUser = progress.userId == userId;
                                  
                                  return _buildParticipantRow(
                                    context, 
                                    progress, 
                                    index + 1,
                                    isHighlighted: isCurrentUser,
                                  );
                                },
                              ),
                              // Botão para ver ranking completo
                              if (sortedList.length > 5)
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: TextButton(
                                    onPressed: () {
                                      context.router.push(ChallengeRankingRoute(challengeId: widget.challengeId));
                                    },
                                    child: const Text('Ver Ranking Completo'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: LoadingIndicator(),
                        ),
                      ),
                      error: (error, stackTrace) => Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Center(
                          child: Column(
                            children: [
                              const Text('Erro ao carregar o ranking.'),
                              TextButton(
                                onPressed: () => ref.refresh(realtimeProgressProvider(widget.challengeId)),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ações
                  if (userId != null && isActive)
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 500),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final participants = challenge.participants;
                            if (!participants.contains(userId)) {
                              // Participar do desafio
                              ref.read(challengeRepositoryProvider).joinChallenge(
                                widget.challengeId,
                                userId,
                              ).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Você entrou no desafio!'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                ref.refresh(challengeByIdProvider(widget.challengeId));
                              }).catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erro ao entrar no desafio: $e')),
                                );
                              });
                            } else {
                              // Convidar amigos (se já for participante)
                              context.router.push(InviteUsersRoute(challengeId: widget.challengeId));
                            }
                          },
                          icon: Icon(
                            challenge.participants.contains(userId) ? Icons.share : Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                          label: Text(
                            challenge.participants.contains(userId) ? 'Convidar Amigos' : 'Participar',
                            style: AppTypography.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: challenge.participants.contains(userId) 
                                ? AppColors.accent 
                                : AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
            opacity: 0.05,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(BuildContext context, ChallengeProgress progress, int position, {bool isHighlighted = false}) {
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

    return Container(
      color: isHighlighted ? AppColors.cream.withOpacity(0.3) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Posição
          SizedBox(
            width: 24,
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
                    textAlign: TextAlign.center,
                  ),
          ),
          const SizedBox(width: 12),
          // Participante
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isHighlighted ? AppColors.primary : AppColors.primaryLight,
                    shape: BoxShape.circle,
                    image: progress.userPhotoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(progress.userPhotoUrl!),
                            fit: BoxFit.cover,
                            onError: (e, stackTrace) {
                              // Tratamento silencioso de erro de imagem
                            },
                          )
                        : null,
                  ),
                  child: progress.userPhotoUrl == null
                      ? Icon(
                          Icons.person,
                          color: isHighlighted ? Colors.white : AppColors.primary,
                          size: 18,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${progress.userName}${isHighlighted ? ' (Você)' : ''}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: isHighlighted || position <= 3 ? FontWeight.w700 : FontWeight.w500,
                      color: isHighlighted ? AppColors.secondary : AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Pontos
          Text(
            '${progress.points}',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isHighlighted 
                  ? AppColors.secondary 
                  : (position <= 3 ? AppColors.primary : AppColors.textDark),
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
} 