import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../features/profile/models/profile_model.dart';
import '../models/challenge.dart';

part 'invite_form_state.freezed.dart';
part 'invite_form_state.g.dart';

/// Estado para o formulário de convite de usuários
@freezed
class InviteFormState with _$InviteFormState {
  const factory InviteFormState({
    /// Lista de todos os perfis disponíveis
    @Default([]) List<Profile> allProfiles,
    
    /// Lista de perfis paginados e filtrados para exibição
    @Default([]) List<Profile> paginatedProfiles,
    
    /// Lista de usuários selecionados para convite
    @Default([]) List<Profile> selectedUsers,
    
    /// Termo de busca atual
    @Default('') String searchQuery,
    
    /// Número da página atual (para paginação)
    @Default(0) int currentPage,
    
    /// Indica se há mais dados para carregar
    @Default(true) bool hasMoreData,
    
    /// Indica se está carregando mais dados
    @Default(false) bool isLoadingMore,
    
    /// Mensagem de erro, se houver
    String? errorMessage,
    
    /// Mensagem de sucesso, se houver
    String? successMessage,
  }) = _InviteFormState;

  /// Criando uma instância de InviteFormState a partir de JSON
  factory InviteFormState.fromJson(Map<String, dynamic> json) => _$InviteFormStateFromJson(json);
} 