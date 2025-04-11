import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

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

@RoutePage()
class ChallengeGroupsScreen extends ConsumerStatefulWidget {
  const ChallengeGroupsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChallengeGroupsScreen> createState() => _ChallengeGroupsScreenState();
}

class _ChallengeGroupsScreenState extends ConsumerState<ChallengeGroupsScreen> {
  late final ImageService imageService;

  @override
  void initState() {
    super.initState();
    imageService = ImageService();
    
    // Iniciar carregamento dos grupos do usuário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserGroups();
    });
  }

  Future<void> _loadUserGroups() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      await ref.read(challengeGroupViewModelProvider.notifier).loadUserGroups(currentUser.id);
    }
  }

  Future<void> _createGroup() async {
    final officialChallengeAsync = ref.read(officialChallengeProvider);
    
    officialChallengeAsync.whenData((challenge) {
      if (challenge == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Desafio oficial não encontrado')),
        );
        return;
      }
      
      _showCreateGroupDialog(challenge.id);
    });
  }

  void _showCreateGroupDialog(String challengeId) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Criar Novo Grupo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Grupo',
                  hintText: 'Ex: Amigos da Academia',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Ex: Grupo para competir com amigos da academia',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nome do grupo é obrigatório')),
                  );
                  return;
                }
                
                final currentUser = ref.read(currentUserProvider);
                if (currentUser == null) return;
                
                await ref.read(challengeGroupViewModelProvider.notifier).createGroup(
                  challengeId: challengeId,
                  creatorId: currentUser.id,
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isNotEmpty 
                      ? descriptionController.text.trim() 
                      : null,
                );
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToGroupDetail(ChallengeGroup group) {
    context.router.pushNamed('/challenges/groups/${group.id}');
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
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Grupos',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserGroups,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGroup,
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
      body: AppTextures.addWaveTexture(
        state.isLoading
            ? const Center(child: LoadingIndicator())
            : state.groups.isEmpty
                ? EmptyState(
                    message: 'Você ainda não participa de nenhum grupo',
                    icon: Icons.group_off,
                    actionLabel: 'Criar Grupo',
                    onAction: _createGroup,
                  )
                : RefreshIndicator(
                    onRefresh: _loadUserGroups,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.groups.length,
                      itemBuilder: (context, index) {
                        final group = state.groups[index];
                        final isCreator = currentUser?.id == group.creatorId;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _navigateToGroupDetail(group),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          group.name,
                                          style: AppTypography.titleMedium.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (isCreator)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Criador',
                                            style: AppTypography.labelSmall.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (group.description != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      group.description!,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 16,
                                        color: AppColors.textLight,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${group.memberCount} participantes',
                                        style: AppTypography.labelMedium.copyWith(
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Ver Ranking',
                                        style: AppTypography.labelMedium.copyWith(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: AppColors.secondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
} 