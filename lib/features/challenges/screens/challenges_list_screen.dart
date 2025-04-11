import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textures.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/router/app_navigator.dart';
import '../../../core/router/app_router.dart';
import '../../../services/image_service.dart';
import '../models/challenge.dart';
import '../viewmodels/challenge_view_model.dart';
import '../providers/challenge_provider.dart';
import '../widgets/challenge_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class ChallengesListScreen extends ConsumerStatefulWidget {
  const ChallengesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends ConsumerState<ChallengesListScreen> {
  late final ImageService imageService;

  @override
  void initState() {
    super.initState();
    imageService = ImageService();
    
    // Carregar desafio oficial por múltiplos caminhos para garantir que algum funcione
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Método 1: Usando o ViewModel
      ref.read(challengeViewModelProvider.notifier).loadOfficialChallenge();
      
      // Método 2: Forçar atualização do provider futuro
      ref.refresh(officialChallengeProvider);
    });
  }

  Future<void> _refreshChallenge() async {
    debugPrint('🔄 Atualizando desafio oficial...');
    // Atualizar ambos para garantir
    await ref.read(challengeViewModelProvider.notifier).loadOfficialChallenge();
    ref.refresh(officialChallengeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(challengeViewModelProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.id;
    
    // Debug log para verificar o estado atual
    final oficialChallenge = state.officialChallenge;
    debugPrint('🧪 Estado na build: isLoading=${state.isLoading}, '
        'officialChallenge=${oficialChallenge?.title}, '
        'errorMessage=${state.errorMessage}');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Desafio Ray',
          style: AppTypography.headingLarge.copyWith(
            color: AppColors.textDark,
          ),
        ),
        actions: [
          // Ícone para acessar convites de grupos
          IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {
              try {
                context.router.pushNamed(AppRoutes.challengeGroupInvites);
              } catch (e) {
                debugPrint('❌ Erro ao navegar para convites: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro: $e')),
                );
              }
            },
            tooltip: 'Convites pendentes',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshChallenge,
        color: AppColors.secondary,
        backgroundColor: Colors.white,
        child: _buildBody(state),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            debugPrint('⏱️ Navegando para grupos de desafio (FAB)');
            context.router.pushNamed(AppRoutes.challengeGroups);
          } catch (e) {
            debugPrint('❌ Erro ao navegar para grupos: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao abrir grupos: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.group),
        tooltip: 'Meus grupos',
      ),
      bottomSheet: null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // índice para a seção de desafios
        onTap: (index) {
          try {
            switch (index) {
              case 0:
                context.router.pushNamed(AppRoutes.home);
                break;
              case 1:
                context.router.pushNamed(AppRoutes.workout);
                break;
              case 2:
                // Já estamos na tela de desafios
                break;
              case 3:
                context.router.pushNamed(AppRoutes.nutrition);
                break;
              case 4:
                context.router.pushNamed(AppRoutes.profile);
                break;
            }
          } catch (e) {
            debugPrint('❌ Erro na navegação: $e');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Desafios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrição',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ChallengeState state) {
    // Verifica se está carregando
    if (state.isLoading) {
      return const LoadingView();
    }
    
    // Verifica se há erro
    if (state.errorMessage != null) {
      return ErrorView(
        message: state.errorMessage!,
        actionLabel: 'Tentar novamente',
        onAction: _refreshChallenge,
      );
    }
    
    // Método 1: Buscar desafio oficial do estado do ViewModel
    final officialChallenge = state.officialChallenge;
    
    // Se não encontrou no estado, tenta o provider assíncrono
    if (officialChallenge == null) {
      // Método 2: Usar o provider específico para desafio oficial
      return ref.watch(officialChallengeProvider).when(
        data: (challenge) {
          if (challenge != null) {
            debugPrint('✅ Desafio encontrado via provider específico: ${challenge.title}');
            return _buildChallengeContent(challenge, state);
          } else {
            return _buildEmptyState();
          }
        },
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(
          message: 'Erro ao carregar desafio oficial: $error',
          actionLabel: 'Tentar novamente',
          onAction: _refreshChallenge,
        ),
      );
    }
    
    // Se chegou aqui, temos o desafio no estado
    return _buildChallengeContent(officialChallenge, state);
  }
  
  Widget _buildEmptyState() {
    // Wrap com ListView para permitir o pull-to-refresh quando não há conteúdo
    return ListView(
      // O physics permite que o usuário puxe para baixo para atualizar
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        // Espaçamento para centralizar o conteúdo
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sports_score,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum desafio oficial disponível no momento',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshChallenge,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildChallengeContent(Challenge challenge, ChallengeState state) {
    return SingleChildScrollView(
      // Garantir que o scroll funcione corretamente
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      // Garantir altura mínima para permitir pull-to-refresh
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 
                     AppBar().preferredSize.height - 
                     MediaQuery.of(context).padding.top - 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.successMessage != null)
              Container(
                width: double.infinity,
                color: Colors.green.shade100,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                child: Text(
                  state.successMessage!,
                  style: TextStyle(color: Colors.green.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Card do desafio oficial
            _buildOfficialChallengeCard(challenge),
            
            const SizedBox(height: 32),
            
            // Seção de grupos
            Text(
              'Meus Grupos',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textDark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Card para acessar grupos
            _buildGroupsCard(),
            
            const SizedBox(height: 32),
            
            // Ranking geral
            Text(
              'Ranking Geral',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textDark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Card para acessar ranking geral
            _buildRankingCard(challenge),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficialChallengeCard(Challenge challenge) {
    final now = DateTime.now();
    final isFuture = challenge.startDate.isAfter(now);
    final isActive = !isFuture && challenge.endDate.isAfter(now);
    final isComplete = challenge.endDate.isBefore(now);
    
    String status;
    Color statusColor;
    
    if (isFuture) {
      status = 'Em breve';
      statusColor = Colors.orange;
    } else if (isActive) {
      status = 'Ativo';
      statusColor = AppColors.secondary;
    } else {
      status = 'Encerrado';
      statusColor = Colors.grey;
    }
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          try {
            // Log de depuração ao clicar
            debugPrint('⏱️ Navegando para detalhes do desafio: ${challenge.id}');
            context.router.pushNamed(AppRoutes.challengeDetail(challenge.id));
          } catch (e) {
            debugPrint('❌ Erro ao navegar: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao abrir detalhes do desafio: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do desafio
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    'assets/images/challenge_default.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey.shade500,
                        ),
                      );
                    },
                  ),
                ),
                // Badge de status
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      status,
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Badge oficial
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Oficial',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Informações do desafio
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    challenge.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textLight,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Participantes
                      Icon(
                        Icons.people,
                        size: 16,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${challenge.participants.length} participantes',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      if (isActive) ...[
                        InkWell(
                          onTap: () async {
                            try {
                              debugPrint('⏱️ Tentando participar do desafio: ${challenge.id}');
                              final userId = ref.read(currentUserProvider)?.id;
                              if (userId != null) {
                                await ref.read(challengeViewModelProvider.notifier)
                                  .joinChallenge(challenge.id, userId);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Você entrou no desafio!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                
                                // Atualizar dados após participar
                                _refreshChallenge();
                              } else {
                                throw Exception('Usuário não autenticado');
                              }
                            } catch (e) {
                              debugPrint('❌ Erro ao participar do desafio: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao participar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                'Participar',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          try {
            debugPrint('⏱️ Navegando para grupos de desafio');
            context.router.pushNamed(AppRoutes.challengeGroups);
          } catch (e) {
            debugPrint('❌ Erro ao navegar para grupos: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao abrir grupos: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.group,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grupos do Desafio',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Crie grupos ou participe dos existentes para competir com seus amigos',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingCard(Challenge challenge) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          try {
            debugPrint('⏱️ Navegando para ranking do desafio: ${challenge.id}');
            context.router.pushNamed(AppRoutes.challengeRanking(challenge.id));
          } catch (e) {
            debugPrint('❌ Erro ao navegar para ranking: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao abrir ranking: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.leaderboard,
                  size: 30,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ranking Geral',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Veja sua posição no ranking geral do desafio',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 