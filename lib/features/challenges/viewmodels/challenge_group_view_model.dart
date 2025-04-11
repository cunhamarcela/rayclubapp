// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../../../core/errors/app_exception.dart';
import '../models/challenge_group.dart';
import '../models/challenge_progress.dart';
import '../repositories/challenge_repository.dart';

/// Estado para gerenciamento de grupos de desafio
class ChallengeGroupState {
  final List<ChallengeGroup> groups;
  final ChallengeGroup? selectedGroup;
  final List<ChallengeGroupInvite> pendingInvites;
  final List<ChallengeProgress> groupRanking;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ChallengeGroupState({
    this.groups = const [],
    this.selectedGroup,
    this.pendingInvites = const [],
    this.groupRanking = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  /// Cria estado inicial
  factory ChallengeGroupState.initial() => ChallengeGroupState();

  /// Cria estado de carregamento
  factory ChallengeGroupState.loading({
    List<ChallengeGroup> groups = const [],
    ChallengeGroup? selectedGroup,
    List<ChallengeGroupInvite> pendingInvites = const [],
    List<ChallengeProgress> groupRanking = const [],
  }) => ChallengeGroupState(
    groups: groups,
    selectedGroup: selectedGroup,
    pendingInvites: pendingInvites,
    groupRanking: groupRanking,
    isLoading: true,
  );

  /// Cria estado de sucesso
  factory ChallengeGroupState.success({
    required List<ChallengeGroup> groups,
    ChallengeGroup? selectedGroup,
    List<ChallengeGroupInvite> pendingInvites = const [],
    List<ChallengeProgress> groupRanking = const [],
    String? message,
  }) => ChallengeGroupState(
    groups: groups,
    selectedGroup: selectedGroup,
    pendingInvites: pendingInvites,
    groupRanking: groupRanking,
    successMessage: message,
  );

  /// Cria estado de erro
  factory ChallengeGroupState.error({
    List<ChallengeGroup> groups = const [],
    ChallengeGroup? selectedGroup,
    List<ChallengeGroupInvite> pendingInvites = const [],
    List<ChallengeProgress> groupRanking = const [],
    required String message,
  }) => ChallengeGroupState(
    groups: groups,
    selectedGroup: selectedGroup,
    pendingInvites: pendingInvites,
    groupRanking: groupRanking,
    errorMessage: message,
  );

  /// Cria uma cópia do estado com campos opcionalmente modificados
  ChallengeGroupState copyWith({
    List<ChallengeGroup>? groups,
    ChallengeGroup? selectedGroup,
    List<ChallengeGroupInvite>? pendingInvites,
    List<ChallengeProgress>? groupRanking,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ChallengeGroupState(
      groups: groups ?? this.groups,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      groupRanking: groupRanking ?? this.groupRanking,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

/// Provider para o ViewModel de grupos de desafio
final challengeGroupViewModelProvider = StateNotifierProvider<ChallengeGroupViewModel, ChallengeGroupState>((ref) {
  final repository = ref.watch(challengeRepositoryProvider);
  return ChallengeGroupViewModel(repository);
});

/// ViewModel para gerenciar grupos de desafio
class ChallengeGroupViewModel extends StateNotifier<ChallengeGroupState> {
  final ChallengeRepository _repository;

  ChallengeGroupViewModel(this._repository) : super(ChallengeGroupState.initial());

  /// Obtém mensagem de erro formatada
  String _getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    return 'Ocorreu um erro: $error';
  }

  /// Carrega grupos dos quais o usuário é membro
  Future<void> loadUserGroups(String userId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      // Obter grupos que o usuário criou ou participa
      final createdGroups = await _repository.getUserCreatedGroups(userId);
      final memberGroups = await _repository.getUserMemberGroups(userId);

      // Combinar e remover duplicatas
      final allGroups = [...createdGroups, ...memberGroups];
      final uniqueGroups = <String, ChallengeGroup>{};
      
      for (final group in allGroups) {
        uniqueGroups[group.id] = group;
      }

      state = ChallengeGroupState.success(
        groups: uniqueGroups.values.toList(),
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Carrega convites pendentes para o usuário
  Future<void> loadPendingInvites(String userId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      final pendingInvites = await _repository.getPendingInvites(userId);

      state = ChallengeGroupState.success(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: pendingInvites,
        groupRanking: state.groupRanking,
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Carrega detalhes de um grupo específico e seu ranking
  Future<void> loadGroupDetails(String groupId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      final group = await _repository.getGroupById(groupId);
      final ranking = await _repository.getGroupRanking(groupId);

      state = ChallengeGroupState.success(
        groups: state.groups,
        selectedGroup: group,
        pendingInvites: state.pendingInvites,
        groupRanking: ranking,
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Cria um novo grupo para o desafio principal
  Future<void> createGroup({
    required String challengeId,
    required String creatorId,
    required String name,
    String? description,
  }) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      final newGroup = await _repository.createGroup(
        challengeId: challengeId,
        creatorId: creatorId,
        name: name,
        description: description,
      );

      // Adicionar o novo grupo à lista de grupos existentes
      final updatedGroups = [...state.groups, newGroup];

      state = ChallengeGroupState.success(
        groups: updatedGroups,
        selectedGroup: newGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: 'Grupo criado com sucesso!',
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Atualiza um grupo existente
  Future<void> updateGroup(ChallengeGroup group) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      await _repository.updateGroup(group);

      // Atualizar o grupo na lista
      final updatedGroups = state.groups.map((g) {
        return g.id == group.id ? group : g;
      }).toList();

      state = ChallengeGroupState.success(
        groups: updatedGroups,
        selectedGroup: group,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: 'Grupo atualizado com sucesso!',
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Exclui um grupo
  Future<void> deleteGroup(String groupId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      await _repository.deleteGroup(groupId);

      // Remover o grupo da lista
      final updatedGroups = state.groups.where((g) => g.id != groupId).toList();

      state = ChallengeGroupState.success(
        groups: updatedGroups,
        selectedGroup: state.selectedGroup?.id == groupId ? null : state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: 'Grupo excluído com sucesso!',
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Convida um usuário para o grupo
  Future<void> inviteUserToGroup(String groupId, String inviterId, String inviteeId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      await _repository.inviteUserToGroup(groupId, inviterId, inviteeId);

      // Atualizar o grupo selecionado, se for o mesmo
      ChallengeGroup? updatedSelectedGroup = state.selectedGroup;
      if (state.selectedGroup?.id == groupId) {
        updatedSelectedGroup = await _repository.getGroupById(groupId);
      }

      // Atualizar o grupo na lista
      final updatedGroups = await _repository.getUserMemberGroups(inviterId);

      state = ChallengeGroupState.success(
        groups: updatedGroups,
        selectedGroup: updatedSelectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: 'Convite enviado com sucesso!',
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Responde a um convite de grupo
  Future<void> respondToInvite(String inviteId, bool accept) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      await _repository.respondToGroupInvite(inviteId, accept);

      // Remover o convite da lista de pendentes
      final updatedInvites = state.pendingInvites
          .where((invite) => invite.id != inviteId)
          .toList();

      // Se aceitou, atualizar a lista de grupos
      List<ChallengeGroup> updatedGroups = state.groups;
      if (accept) {
        // Buscar o ID do usuário atual
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null) {
          updatedGroups = await _repository.getUserMemberGroups(userId);
        }
      }

      state = ChallengeGroupState.success(
        groups: updatedGroups,
        selectedGroup: state.selectedGroup,
        pendingInvites: updatedInvites,
        groupRanking: state.groupRanking,
        message: accept ? 'Convite aceito com sucesso!' : 'Convite recusado.',
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Remove um usuário do grupo
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      await _repository.removeUserFromGroup(groupId, userId);

      // Atualizar o grupo selecionado, se for o mesmo
      ChallengeGroup? updatedSelectedGroup = state.selectedGroup;
      if (state.selectedGroup?.id == groupId) {
        updatedSelectedGroup = await _repository.getGroupById(groupId);
      }

      // Recarregar o ranking se necessário
      List<ChallengeProgress> updatedRanking = state.groupRanking;
      if (state.selectedGroup?.id == groupId) {
        updatedRanking = await _repository.getGroupRanking(groupId);
      }

      state = ChallengeGroupState.success(
        groups: state.groups,
        selectedGroup: updatedSelectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: updatedRanking,
        message: 'Usuário removido com sucesso!',
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Atualiza o ranking do grupo
  Future<void> refreshGroupRanking(String groupId) async {
    try {
      state = ChallengeGroupState.loading(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
      );

      final updatedRanking = await _repository.getGroupRanking(groupId);

      state = ChallengeGroupState.success(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: updatedRanking,
      );
    } catch (e) {
      state = ChallengeGroupState.error(
        groups: state.groups,
        selectedGroup: state.selectedGroup,
        pendingInvites: state.pendingInvites,
        groupRanking: state.groupRanking,
        message: _getErrorMessage(e),
      );
    }
  }

  /// Limpa erros e mensagens de sucesso
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }
} 