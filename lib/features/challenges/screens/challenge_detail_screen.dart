import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../viewmodels/challenge_view_model.dart';
import '../models/challenge.dart';
import '../../../core/providers/auth_provider.dart';
import 'invite_users_screen.dart';

@RoutePage()
class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;
  
  const ChallengeDetailScreen({
    @PathParam() required this.challengeId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Carrega os detalhes do desafio quando a tela é construída
    ref.watch(challengeViewModelProvider);
    
    // Quando o ID do desafio muda, carrega os novos detalhes
    ref.listen<String>(
      Provider((ref) => challengeId),
      (previous, current) {
        if (previous != current) {
          ref.read(challengeViewModelProvider.notifier).getChallengeDetails(current);
        }
      },
    );
    
    // Carrega os detalhes do desafio quando a tela é montada pela primeira vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(challengeViewModelProvider.notifier).getChallengeDetails(challengeId);
    });
    
    final state = ref.watch(challengeViewModelProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    return state.maybeWhen(
      loading: () => const Scaffold(body: LoadingView()),
      error: (message) => Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.pop(),
          ),
        ),
        body: ErrorView(
          message: message,
          onRetry: () => ref.read(challengeViewModelProvider.notifier).getChallengeDetails(challengeId),
        ),
      ),
      success: (_, __, selectedChallenge, __, progressList, message, _____) {
        if (selectedChallenge == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Desafio não encontrado')),
            body: const Center(
              child: Text('Não foi possível encontrar este desafio'),
            ),
          );
        }
        
        return _buildContent(context, ref, selectedChallenge, progressList, message, currentUser);
      },
      orElse: () => const Scaffold(body: LoadingView()),
    );
  }
  
  Scaffold _buildContent(
    BuildContext context,
    WidgetRef ref,
    Challenge challenge,
    List<ChallengeProgress> progressList,
    String? message,
    UserData? currentUser,
  ) {
    final userId = currentUser?.id ?? '';
    final userName = currentUser?.name ?? 'Usuário';
    final isParticipating = challenge.participants.contains(userId);
    final isCreator = challenge.creatorId == userId;
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                challenge.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagem do desafio ou placeholder
                  if (challenge.imageUrl != null)
                    Image.network(
                      challenge.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.asset(
                      'assets/images/challenge_placeholder.jpg',
                      fit: BoxFit.cover,
                    ),
                  // Gradiente para melhor legibilidade do texto
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (isCreator)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.router.pushNamed('/challenges/edit/${challenge.id}'),
                ),
              if (isCreator)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, ref, challenge.id),
                ),
            ],
          ),
          if (message != null)
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: Colors.green.shade100,
                padding: const EdgeInsets.all(8),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.green.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge de desafio oficial
                  if (challenge.isOfficial)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.shade700, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 16, color: Colors.amber.shade800),
                          const SizedBox(width: 4),
                          Text(
                            'Desafio Oficial Ray',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Datas do desafio
                  _buildInfoCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Período',
                    content: '${dateFormat.format(challenge.startDate)} até ${dateFormat.format(challenge.endDate)}',
                  ),
                  const SizedBox(height: 16),
                  // Recompensa
                  _buildInfoCard(
                    context,
                    icon: Icons.star,
                    title: 'Recompensa',
                    content: '${challenge.reward} pontos',
                  ),
                  const SizedBox(height: 16),
                  // Descrição
                  _buildInfoCard(
                    context,
                    icon: Icons.description,
                    title: 'Descrição',
                    content: challenge.description,
                  ),
                  const SizedBox(height: 16),
                  // Participantes
                  _buildInfoCard(
                    context,
                    icon: Icons.people,
                    title: 'Participantes',
                    content: challenge.participants.isEmpty
                        ? 'Nenhum participante ainda'
                        : '${challenge.participants.length} participante(s)',
                  ),
                  const SizedBox(height: 24),
                  
                  // Botões de ação
                  _buildActionButtons(context, ref, challenge, isParticipating, isCreator, userId, userName),
                  
                  const SizedBox(height: 24),
                  
                  // Ranking
                  _buildRankingSection(context, ref, progressList, userId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Challenge challenge,
    bool isParticipating,
    bool isCreator,
    String userId,
    String userName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botão principal (participar/sair)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isParticipating ? Colors.red : AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              final viewModel = ref.read(challengeViewModelProvider.notifier);
              if (isParticipating) {
                viewModel.leaveChallenge(
                  challengeId: challenge.id,
                  userId: userId,
                );
              } else {
                viewModel.joinChallenge(
                  challengeId: challenge.id,
                  userId: userId,
                );
              }
            },
            child: Text(
              isParticipating ? 'Sair do Desafio' : 'Participar',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Botão de convidar (apenas para criador ou participantes)
        if (isParticipating || isCreator)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppColors.secondary),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InviteUsersScreen(
                      challengeId: challenge.id,
                      challengeTitle: challenge.title,
                      currentUserId: userId,
                      currentUserName: userName,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.person_add, color: AppColors.secondary),
              label: Text(
                'Convidar Usuários',
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Botão de atualizar progresso (apenas para participantes)
        if (isParticipating)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppColors.primary),
              ),
              onPressed: () => _updateProgress(context, ref, challenge.id, userId, userName),
              icon: Icon(Icons.update, color: AppColors.primary),
              label: Text(
                'Atualizar Progresso',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildRankingSection(
    BuildContext context, 
    WidgetRef ref,
    List<ChallengeProgress> progressList,
    String userId,
  ) {
    // Ordena a lista de progresso por pontos (do maior para o menor)
    final sortedProgress = List<ChallengeProgress>.from(progressList)
      ..sort((a, b) => b.points.compareTo(a.points));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ranking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => ref.read(challengeViewModelProvider.notifier)
                  .loadChallengeRanking(challengeId),
              child: const Text('Atualizar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250, // Altura fixa para a lista
          child: ListView.builder(
            itemCount: sortedProgress.length > 5 ? 5 : sortedProgress.length,
            itemBuilder: (context, index) {
              final progress = sortedProgress[index];
              final isCurrentUser = progress.userId == userId;
              
              return _buildRankingItem(index, progress, isCurrentUser);
            },
          ),
        ),
        if (sortedProgress.length > 5)
          TextButton(
            onPressed: () => _showFullRanking(context, sortedProgress, userId),
            child: const Text('Ver Ranking Completo'),
          ),
      ],
    );
  }
  
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
  
  void _confirmDelete(BuildContext context, WidgetRef ref, String challengeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Desafio'),
        content: const Text('Tem certeza que deseja excluir este desafio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.router.pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
  
  void _updateProgress(
    BuildContext context, 
    WidgetRef ref, 
    String challengeId, 
    String userId,
    String userName,
  ) {
    // Simular valores para demonstração
    double progress = 0.0;
    int points = 0;
    
    // Obter foto do usuário atual se disponível
    final userProfile = ref.read(currentUserProvider);
    final String? userPhotoUrl = userProfile?.photoUrl;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Atualizar Progresso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Defina seu progresso atual: ${(progress * 100).toInt()}%'),
                Slider(
                  value: progress,
                  onChanged: (value) {
                    setState(() {
                      progress = value;
                      // Calcula pontos com base no progresso (exemplo simples)
                      points = (progress * 100).toInt();
                    });
                  },
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(progress * 100).toInt()}%',
                ),
                const SizedBox(height: 16),
                Text('Pontos: $points'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(challengeViewModelProvider.notifier).updateUserProgress(
                    challengeId: challengeId,
                    userId: userId,
                    userName: userName,
                    userPhotoUrl: userPhotoUrl,
                    points: points,
                    completionPercentage: progress,
                  );
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Color _getRankingColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber[700]!;
      case 1:
        return Colors.grey[500]!;
      case 2:
        return Colors.brown[400]!;
      default:
        return Colors.blue[300]!;
    }
  }
  
  Widget _buildRankingItem(int index, ChallengeProgress progress, bool isCurrentUser) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isCurrentUser ? Colors.blue[50] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isCurrentUser
            ? BorderSide(color: AppColors.primary)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getRankingColor(index),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundImage: progress.userPhotoUrl != null
                  ? NetworkImage(progress.userPhotoUrl!)
                  : null,
              child: progress.userPhotoUrl == null
                  ? Text(progress.userName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (isCurrentUser)
                    Text(
                      'Você',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${progress.points} pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${(progress.completionPercentage * 100).toInt()}% concluído',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFullRanking(
    BuildContext context, 
    List<ChallengeProgress> progressList,
    String userId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 16),
                    child: Text(
                      'Ranking Completo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: progressList.length,
                      itemBuilder: (context, index) {
                        final progress = progressList[index];
                        final isCurrentUser = progress.userId == userId;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: isCurrentUser ? Colors.blue[50] : null,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _getRankingColor(index),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: progress.userPhotoUrl != null
                                      ? NetworkImage(progress.userPhotoUrl!)
                                      : null,
                                  child: progress.userPhotoUrl == null
                                      ? Text(progress.userName[0].toUpperCase())
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        progress.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (isCurrentUser)
                                        Text(
                                          'Você',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${progress.points} pts',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${(progress.completionPercentage * 100).toInt()}% concluído',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
} 