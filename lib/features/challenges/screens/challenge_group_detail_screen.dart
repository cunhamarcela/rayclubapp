import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_textures.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../services/image_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../providers/challenge_provider.dart';
import '../viewmodels/challenge_group_view_model.dart';
import '../models/challenge_group.dart';
import '../models/challenge_progress.dart';
import '../../profile/providers/user_provider.dart';

@RoutePage()
class ChallengeGroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const ChallengeGroupDetailScreen({
    Key? key,
    @PathParam('groupId') required this.groupId,
  }) : super(key: key);

  @override
  ConsumerState<ChallengeGroupDetailScreen> createState() => _ChallengeGroupDetailScreenState();
}

class _ChallengeGroupDetailScreenState extends ConsumerState<ChallengeGroupDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final imageService = ImageService();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Iniciar carregamento de dados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroupDetails();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadGroupDetails() async {
    await ref.read(challengeGroupViewModelProvider.notifier).loadGroupDetails(widget.groupId);
  }
  
  Future<void> _inviteUser() async {
    final usersProvider = ref.read(userListProvider);
    
    final searchController = TextEditingController();
    List<UserBasic> filteredUsers = [];
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Convidar Participante'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nome',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      if (value.trim().length >= 3) {
                        final users = usersProvider.maybeWhen(
                          data: (data) => data,
                          orElse: () => <UserBasic>[],
                        );
                        
                        setState(() {
                          filteredUsers = users
                              .where((user) => 
                                  user.name.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      } else {
                        setState(() {
                          filteredUsers = [];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: filteredUsers.isEmpty
                        ? const Center(
                            child: Text('Digite pelo menos 3 caracteres para buscar'),
                          )
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  backgroundImage: user.photoUrl != null 
                                      ? NetworkImage(user.photoUrl!) 
                                      : null,
                                  child: user.photoUrl == null
                                      ? Text(
                                          user.name.isNotEmpty ? user.name[0] : '?',
                                          style: const TextStyle(color: Colors.white),
                                        )
                                      : null,
                                ),
                                title: Text(user.name),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  
                                  final currentUser = ref.read(currentUserProvider);
                                  if (currentUser == null) return;
                                  
                                  await ref.read(challengeGroupViewModelProvider.notifier)
                                      .inviteUserToGroup(
                                        widget.groupId,
                                        currentUser.id,
                                        user.id,
                                      );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showRemoveUserDialog(ChallengeGroup group, String memberId, String memberName) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    
    // Verificar se o usuário atual é o criador do grupo
    if (currentUser.id != group.creatorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Somente o criador do grupo pode remover participantes')),
      );
      return;
    }
    
    // Não permitir remover o criador
    if (memberId == group.creatorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O criador do grupo não pode ser removido')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover Participante'),
          content: Text('Deseja realmente remover $memberName do grupo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                await ref.read(challengeGroupViewModelProvider.notifier)
                    .removeUserFromGroup(group.id, memberId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(challengeGroupViewModelProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    // Mostrar mensagem de sucesso, se houver
    if (state.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.successMessage!)),
        );
        ref.read(challengeGroupViewModelProvider.notifier).clearMessages();
      });
    }
    
    // Mostrar mensagem de erro, se houver
    if (state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(challengeGroupViewModelProvider.notifier).clearMessages();
      });
    }
    
    final group = state.selectedGroup;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          group?.name ?? 'Detalhes do Grupo',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGroupDetails,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.secondary,
          tabs: const [
            Tab(text: 'Ranking'),
            Tab(text: 'Participantes'),
          ],
        ),
      ),
      floatingActionButton: group != null && 
                           currentUser != null && 
                           group.creatorId == currentUser.id
          ? FloatingActionButton(
              onPressed: _inviteUser,
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.person_add),
            )
          : null,
      body: AppTextures.addWaveTexture(
        state.isLoading
            ? const Center(child: LoadingIndicator())
            : group == null
                ? EmptyState(
                    message: 'Grupo não encontrado',
                    icon: Icons.error_outline,
                    actionLabel: 'Tentar novamente',
                    onAction: _loadGroupDetails,
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRankingTab(group, currentUser?.id),
                      _buildMembersTab(group, currentUser?.id),
                    ],
                  ),
      ),
    );
  }

  Widget _buildRankingTab(ChallengeGroup group, String? currentUserId) {
    final groupState = ref.watch(challengeGroupViewModelProvider);
    final ranking = groupState.groupRanking;
    
    if (ranking.isEmpty) {
      return const Center(
        child: Text('Ainda não há participantes com pontuação registrada'),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(challengeGroupViewModelProvider.notifier).refreshGroupRanking(group.id);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ranking.length,
        itemBuilder: (context, index) {
          final progress = ranking[index];
          final isCurrentUser = progress.userId == currentUserId;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: isCurrentUser ? 3 : 1,
            color: isCurrentUser ? AppColors.cream.withOpacity(0.3) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isCurrentUser
                  ? BorderSide(color: AppColors.secondary.withOpacity(0.5), width: 1.5)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Posição no ranking
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _getPositionColor(progress.position),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${progress.position}',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Foto do usuário
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: progress.userPhotoUrl != null
                        ? NetworkImage(progress.userPhotoUrl!)
                        : null,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: progress.userPhotoUrl == null
                        ? Text(
                            progress.userName.isNotEmpty ? progress.userName[0] : '?',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Nome e pontuação
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.userName,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${progress.points} pontos',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Barra de progresso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(progress.completionPercentage * 100).toInt()}%',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          value: progress.completionPercentage,
                          backgroundColor: AppColors.cream,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                          borderRadius: BorderRadius.circular(10),
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
    );
  }

  Widget _buildMembersTab(ChallengeGroup group, String? currentUserId) {
    if (group.memberIds.isEmpty) {
      return const Center(
        child: Text('Este grupo ainda não tem participantes'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: group.memberIds.length,
      itemBuilder: (context, index) {
        final memberId = group.memberIds[index];
        final isCurrentUser = memberId == currentUserId;
        final isCreator = memberId == group.creatorId;
        
        // Obter informações do usuário 
        final userAsync = ref.watch(userProfileProvider(memberId));
        
        return userAsync.when(
          data: (user) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: isCurrentUser ? 2 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: user.photoUrl == null
                      ? Text(
                          user.name.isNotEmpty ? user.name[0] : '?',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  user.name,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  isCreator ? 'Criador do grupo' : 'Participante',
                  style: AppTypography.bodySmall.copyWith(
                    color: isCreator ? AppColors.secondary : AppColors.textLight,
                  ),
                ),
                trailing: !isCreator && currentUserId == group.creatorId
                    ? IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () => _showRemoveUserDialog(group, memberId, user.name),
                      )
                    : null,
              ),
            );
          },
          loading: () => const ListTile(
            leading: CircleAvatar(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            title: Text('Carregando...'),
          ),
          error: (_, __) => ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.error_outline),
            ),
            title: const Text('Erro ao carregar usuário'),
            subtitle: Text(memberId),
          ),
        );
      },
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber.shade700; // Gold
      case 2:
        return Colors.blueGrey.shade400; // Silver
      case 3:
        return Colors.brown.shade400; // Bronze
      default:
        return AppColors.primary.withOpacity(0.7);
    }
  }
} 