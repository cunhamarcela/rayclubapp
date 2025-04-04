import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../features/profile/models/profile_model.dart';
import '../models/challenge.dart';
import '../viewmodels/challenge_view_model.dart';
import '../viewmodels/invite_form_view_model.dart';

/// Tela para convidar usuários para um desafio
class InviteUsersScreen extends ConsumerWidget {
  final String challengeId;
  final String challengeTitle;
  final String currentUserId;
  final String currentUserName;

  /// Controlador para o campo de busca
  final TextEditingController _searchController = TextEditingController();
  
  /// ScrollController para detectar quando chegou ao final da lista
  final ScrollController _scrollController = ScrollController();

  InviteUsersScreen({
    Key? key,
    required this.challengeId,
    required this.challengeTitle,
    required this.currentUserId,
    required this.currentUserName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializa o ScrollController para carregar mais dados ao rolar
    _initScrollController(ref);

    // Obtém o estado do formulário de convites
    final inviteFormState = ref.watch(inviteFormViewModelProvider);
    
    // Carrega perfis quando a tela é construída pela primeira vez
    _loadProfiles(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convidar Usuários'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchField(ref),
          _buildSelectedUsersList(inviteFormState.selectedUsers),
          Expanded(
            child: _buildUsersList(context, ref, inviteFormState),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, ref, inviteFormState.selectedUsers),
    );
  }

  /// Inicializa o controlador de scroll
  void _initScrollController(WidgetRef ref) {
    if (!_scrollController.hasListeners) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >= 
            _scrollController.position.maxScrollExtent - 200) {
          // Quando estamos próximos do final da lista, carrega mais dados
          ref.read(inviteFormViewModelProvider.notifier).loadMoreProfiles();
        }
      });
    }
  }

  /// Carrega os perfis na inicialização
  void _loadProfiles(WidgetRef ref) {
    // Carrega a lista de usuários ao iniciar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inviteFormViewModelProvider.notifier).loadProfiles();
    });
  }

  /// Constrói o campo de busca
  Widget _buildSearchField(WidgetRef ref) {
    final inviteFormNotifier = ref.read(inviteFormViewModelProvider.notifier);
    final searchQuery = ref.watch(inviteFormViewModelProvider).searchQuery;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar usuários...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty 
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    inviteFormNotifier.clearSearchQuery();
                  },
                ) 
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.grey[100],
          filled: true,
        ),
        onChanged: (value) {
          inviteFormNotifier.updateSearchQuery(value);
        },
      ),
    );
  }

  /// Constrói a lista de usuários selecionados
  Widget _buildSelectedUsersList(List<Profile> selectedUsers) {
    if (selectedUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usuários selecionados (${selectedUsers.length})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedUsers.map((user) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(user.name?[0] ?? 'U')
                      : null,
                ),
                label: Text(user.name ?? 'Usuário'),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _onUserSelected(user, ref),
              );
            }).toList(),
          ),
          const Divider(),
        ],
      ),
    );
  }

  /// Constrói a lista de usuários
  Widget _buildUsersList(BuildContext context, WidgetRef ref, InviteFormState state) {
    if (state.errorMessage != null) {
      return AppErrorWidget(
        message: state.errorMessage!,
        onRetry: () => ref.read(inviteFormViewModelProvider.notifier).loadProfiles(),
      );
    }

    if (state.paginatedProfiles.isEmpty && state.allProfiles.isEmpty) {
      return const Center(child: AppLoading());
    }

    if (state.paginatedProfiles.isEmpty) {
      return const AppEmptyState(
        message: 'Nenhum usuário encontrado para este termo',
        icon: Icons.search_off,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.paginatedProfiles.length + (state.hasMoreData ? 1 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        // Se for o último item e temos mais dados, mostrar o loader
        if (index == state.paginatedProfiles.length && state.hasMoreData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Se for um item normal, mostrar o perfil
        if (index < state.paginatedProfiles.length) {
          final profile = state.paginatedProfiles[index];
          final isSelected = state.selectedUsers.any((u) => u.id == profile.id);
          return _buildUserItem(profile, isSelected, ref);
        }
        
        return null;
      },
    );
  }

  /// Constrói um item de usuário
  Widget _buildUserItem(Profile profile, bool isSelected, WidgetRef ref) {
    // Não mostrar o usuário atual na lista
    if (profile.id == currentUserId) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _onUserSelected(profile, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: profile.photoUrl != null
                    ? NetworkImage(profile.photoUrl!)
                    : null,
                radius: 24,
                child: profile.photoUrl == null
                    ? Text(profile.name?[0] ?? 'U',
                        style: const TextStyle(fontSize: 18))
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name ?? 'Usuário',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (profile.email != null)
                      Text(
                        profile.email!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                activeColor: AppTheme.primaryColor,
                onChanged: (_) => _onUserSelected(profile, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói a barra inferior com botões de ação
  Widget _buildBottomBar(BuildContext context, WidgetRef ref, List<Profile> selectedUsers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: selectedUsers.isEmpty
                  ? null
                  : () => _sendInvites(context, ref, selectedUsers),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Convidar ${selectedUsers.length} ${selectedUsers.length == 1 ? 'Usuário' : 'Usuários'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Envia convites para os usuários selecionados
  void _sendInvites(BuildContext context, WidgetRef ref, List<Profile> selectedUsers) async {
    final challengeViewModel = ref.read(challengeViewModelProvider.notifier);
    
    // Mostrar diálogo de progresso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Enviando convites...'),
          ],
        ),
      ),
    );
    
    try {
      // Enviar convites para cada usuário selecionado
      for (final user in selectedUsers) {
        await challengeViewModel.inviteUserToChallenge(
          challengeId: challengeId, 
          challengeTitle: challengeTitle,
          inviterId: currentUserId,
          inviterName: currentUserName,
          inviteeId: user.id,
        );
      }
      
      // Fechar diálogo de progresso
      Navigator.of(context).pop();
      
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Convites enviados com sucesso para ${selectedUsers.length} ${selectedUsers.length == 1 ? 'usuário' : 'usuários'}!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      
      // Voltar para a tela anterior
      Navigator.of(context).pop();
    } catch (e) {
      // Fechar diálogo de progresso
      Navigator.of(context).pop();
      
      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar convites: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Trata a seleção/desseleção de um usuário
  void _onUserSelected(Profile profile, WidgetRef ref) {
    ref.read(inviteFormViewModelProvider.notifier).toggleUserSelection(profile);
  }
} 