import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_exception.dart';
import '../models/challenge.dart';
import '../repositories/challenge_repository.dart';

/// Provider para o ChallengeViewModel
final challengeViewModelProvider = StateNotifierProvider<ChallengeViewModel, ChallengeState>((ref) {
  final repository = ref.watch(challengeRepositoryProvider);
  return ChallengeViewModel(repository: repository);
});

/// Helper class para extrair dados do estado atual de forma mais segura
class ChallengeStateHelper {
  /// Extrai a lista de desafios do estado atual
  static List<Challenge> getChallenges(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => challenges,
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) => challenges,
      orElse: () => <Challenge>[],
    );
  }
  
  /// Extrai a lista de desafios filtrados do estado atual
  static List<Challenge> getFilteredChallenges(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => filteredChallenges,
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) => filteredChallenges,
      orElse: () => <Challenge>[],
    );
  }
  
  /// Extrai o desafio selecionado do estado atual
  static Challenge? getSelectedChallenge(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => selectedChallenge,
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) => selectedChallenge,
      orElse: () => null,
    );
  }
  
  /// Extrai a lista de convites pendentes do estado atual
  static List<ChallengeInvite> getPendingInvites(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => pendingInvites,
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) => pendingInvites,
      orElse: () => <ChallengeInvite>[],
    );
  }
  
  /// Extrai a lista de progresso do estado atual
  static List<ChallengeProgress> getProgressList(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => progressList,
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) => progressList,
      orElse: () => <ChallengeProgress>[],
    );
  }
  
  /// Obtém a mensagem de sucesso do estado
  static String? getSuccessMessage(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => successMessage,
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) => message,
      orElse: () => null,
    );
  }
  
  /// Obtém a mensagem de erro do estado
  static String? getErrorMessage(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => errorMessage,
      orElse: () => null,
    );
  }
  
  /// Verifica se o estado está carregando
  static bool isLoading(ChallengeState state) {
    return state.maybeWhen(
      (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, isLoading, errorMessage, successMessage) => isLoading,
      loading: () => true,
      orElse: () => false,
    );
  }
}

/// ViewModel para gerenciar desafios
class ChallengeViewModel extends StateNotifier<ChallengeState> {
  final ChallengeRepository _repository;

  ChallengeViewModel({required ChallengeRepository repository})
      : _repository = repository,
        super(const ChallengeState.initial()) {
    loadChallenges();
  }

  /// Extrai mensagem de erro de uma exceção
  String _getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    
    // Mapeamento de erros comuns para mensagens amigáveis ao usuário
    if (error is DatabaseException) {
      return 'Erro ao acessar banco de dados. Por favor, tente novamente mais tarde.';
    }
    
    if (error is NetworkException) {
      return 'Erro de conexão. Verifique sua internet e tente novamente.';
    }
    
    if (error is AuthException) {
      return 'Erro de autenticação. Faça login novamente.';
    }
    
    if (error is ValidationException) {
      return 'Dados inválidos. Verifique suas informações e tente novamente.';
    }
    
    // Para erros não mapeados, forneça uma mensagem genérica em vez de expor detalhes técnicos
    return 'Ocorreu um erro inesperado. Por favor, tente novamente.';
  }

  /// Carrega todos os desafios do repositório
  Future<void> loadChallenges() async {
    try {
      state = const ChallengeState.loading();
      final challenges = await _repository.getChallenges();
      state = ChallengeState.success(
        challenges: challenges,
        filteredChallenges: challenges,
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Carrega desafios criados por um usuário específico
  Future<void> loadUserChallenges(String userId) async {
    try {
      state = const ChallengeState.loading();
      final challenges = await _repository.getUserChallenges(userId);
      state = ChallengeState.success(
        challenges: challenges,
        filteredChallenges: challenges,
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Carrega desafios ativos (aqueles que ainda não terminaram)
  Future<void> loadActiveChallenges() async {
    try {
      state = const ChallengeState.loading();
      final challenges = await _repository.getActiveChallenges();
      state = ChallengeState.success(
        challenges: challenges,
        filteredChallenges: challenges,
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Carrega o desafio oficial atual da Ray
  Future<void> loadOfficialChallenge() async {
    try {
      state = const ChallengeState.loading();
      final challenge = await _repository.getOfficialChallenge();
      
      if (challenge != null) {
        state = ChallengeState.success(
          challenges: [challenge],
          filteredChallenges: [challenge],
          selectedChallenge: challenge,
        );
      } else {
        state = const ChallengeState.error(
          message: 'Nenhum desafio oficial encontrado',
        );
      }
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Carrega o desafio principal (em destaque)
  Future<void> loadMainChallenge() async {
    try {
      state = const ChallengeState.loading();
      final challenge = await _repository.getMainChallenge();
      
      if (challenge != null) {
        state = ChallengeState.success(
          challenges: [challenge],
          filteredChallenges: [challenge],
          selectedChallenge: challenge,
        );
      } else {
        state = const ChallengeState.error(
          message: 'Nenhum desafio principal encontrado',
        );
      }
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Obtém detalhes de um desafio específico
  Future<void> getChallengeDetails(String challengeId) async {
    try {
      state = const ChallengeState.loading();
      final challenge = await _repository.getChallengeById(challengeId);
      
      // Mantém a lista atual de desafios
      final currentChallenges = ChallengeStateHelper.getChallenges(state);
      
      // Obtém o ranking/progresso para este desafio
      final progressList = await _repository.getChallengeRanking(challengeId);
      
      state = ChallengeState.success(
        challenges: currentChallenges,
        filteredChallenges: currentChallenges,
        selectedChallenge: challenge,
        progressList: progressList,
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Cria um novo desafio
  Future<void> createChallenge(Challenge challenge) async {
    try {
      state = const ChallengeState.loading();
      final newChallenge = await _repository.createChallenge(challenge);
      
      // Mantém a lista atual de desafios e adiciona o novo
      final currentChallenges = ChallengeStateHelper.getChallenges(state);
      
      final updatedChallenges = [...currentChallenges, newChallenge];
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: newChallenge,
        message: 'Desafio criado com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Atualiza um desafio existente
  Future<void> updateChallenge(Challenge challenge) async {
    try {
      state = const ChallengeState.loading();
      await _repository.updateChallenge(challenge);
      
      // Mantém a lista atual de desafios e atualiza o modificado
      final currentChallenges = ChallengeStateHelper.getChallenges(state);
      final currentProgress = ChallengeStateHelper.getProgressList(state);
      
      final updatedChallenges = currentChallenges.map((c) {
        return c.id == challenge.id ? challenge : c;
      }).toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: challenge,
        progressList: currentProgress,
        message: 'Desafio atualizado com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Participa de um desafio
  Future<void> joinChallenge({
    required String challengeId,
    required String userId,
  }) async {
    try {
      state = const ChallengeState.loading();
      await _repository.joinChallenge(challengeId: challengeId, userId: userId);
      
      // Obtém os detalhes atualizados do desafio após a participação
      final updatedChallenge = await _repository.getChallengeById(challengeId);
      
      // Mantém a lista atual de desafios e atualiza o modificado
      final currentChallenges = ChallengeStateHelper.getChallenges(state);
      
      final updatedChallenges = currentChallenges.map((c) {
        return c.id == challengeId ? updatedChallenge : c;
      }).toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: updatedChallenge,
        message: 'Você entrou no desafio com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Sai de um desafio
  Future<void> leaveChallenge({
    required String challengeId,
    required String userId,
  }) async {
    try {
      state = const ChallengeState.loading();
      await _repository.leaveChallenge(challengeId: challengeId, userId: userId);
      
      // Obtém os detalhes atualizados do desafio após sair
      final updatedChallenge = await _repository.getChallengeById(challengeId);
      
      // Mantém a lista atual de desafios e atualiza o modificado
      final currentChallenges = ChallengeStateHelper.getChallenges(state);
      
      final updatedChallenges = currentChallenges.map((c) {
        return c.id == challengeId ? updatedChallenge : c;
      }).toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: updatedChallenge,
        message: 'Você saiu do desafio com sucesso',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Convida um usuário para um desafio
  Future<void> inviteUserToChallenge({
    required String challengeId,
    required String challengeTitle,
    required String inviterId,
    required String inviterName,
    required String inviteeId,
  }) async {
    try {
      state = const ChallengeState.loading();
      final invite = await _repository.inviteUserToChallenge(
        challengeId: challengeId,
        challengeTitle: challengeTitle,
        inviterId: inviterId,
        inviterName: inviterName,
        inviteeId: inviteeId,
      );
      
      // Obtém o desafio atualizado
      final updatedChallenge = await _repository.getChallengeById(challengeId);
      
      // Mantém a lista atual de desafios e atualiza o modificado
      final currentChallenges = ChallengeStateHelper.getChallenges(state);
      
      final updatedChallenges = currentChallenges.map((c) {
        return c.id == challengeId ? updatedChallenge : c;
      }).toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: updatedChallenge,
        message: 'Convite enviado com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Carrega convites pendentes para um usuário
  Future<void> loadPendingInvites(String userId) async {
    try {
      state = const ChallengeState.loading();
      final pendingInvites = await _repository.getPendingInvites(userId);
      
      // Mantém os dados atuais
      final challenges = ChallengeStateHelper.getChallenges(state);
      final filteredChallenges = ChallengeStateHelper.getFilteredChallenges(state);
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(state);
      
      state = ChallengeState.success(
        challenges: challenges,
        filteredChallenges: filteredChallenges,
        selectedChallenge: selectedChallenge,
        pendingInvites: pendingInvites,
        message: pendingInvites.isEmpty 
            ? 'Você não tem convites pendentes' 
            : 'Convites pendentes carregados',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Responde a um convite (aceita ou recusa)
  Future<void> respondToInvite({
    required String inviteId,
    required InviteStatus status,
  }) async {
    try {
      state = const ChallengeState.loading();
      await _repository.respondToInvite(
        inviteId: inviteId,
        status: status,
      );
      
      // Atualiza a lista de convites pendentes
      final pendingInvites = ChallengeStateHelper.getPendingInvites(state);
      
      // Identifica o usuário atual para recarregar convites
      final userId = pendingInvites.isNotEmpty ? pendingInvites.first.inviteeId : null;
      
      if (userId != null) {
        await loadPendingInvites(userId);
      } else {
        final successMessage = status == InviteStatus.accepted
            ? 'Você aceitou o convite e entrou no desafio!'
            : 'Você recusou o convite';
            
        state = ChallengeState.success(
          challenges: [],
          filteredChallenges: [],
          message: successMessage,
        );
      }
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Atualiza o progresso de um usuário em um desafio
  Future<void> updateUserProgress({
    required String challengeId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required int points,
    required double completionPercentage,
  }) async {
    try {
      // Validação de IDs
      if (challengeId.trim().isEmpty) {
        throw const ValidationException(message: 'ID do desafio não pode estar vazio');
      }
      
      if (userId.trim().isEmpty) {
        throw const ValidationException(message: 'ID do usuário não pode estar vazio');
      }
      
      // Sanitização e validação do nome de usuário
      final sanitizedName = _sanitizeString(userName);
      if (sanitizedName.isEmpty) {
        throw const ValidationException(message: 'Nome do usuário não pode estar vazio');
      }
      
      // Sanitização da URL da foto do usuário
      final sanitizedPhotoUrl = userPhotoUrl != null ? _sanitizeString(userPhotoUrl) : null;
      
      // Validação de valores numéricos
      if (points < 0) {
        throw const ValidationException(message: 'Os pontos não podem ser negativos');
      }
      
      if (points > 1000000) {
        throw const ValidationException(message: 'Valor de pontos excede o limite permitido');
      }
      
      if (completionPercentage < 0 || completionPercentage > 1) {
        throw const ValidationException(message: 'O percentual de conclusão deve estar entre 0 e 100%');
      }
      
      state = const ChallengeState.loading();
      await _repository.updateUserProgress(
        challengeId: challengeId,
        userId: userId,
        userName: sanitizedName,
        userPhotoUrl: sanitizedPhotoUrl,
        points: points,
        completionPercentage: completionPercentage,
      );
      
      // Obtém o ranking atualizado
      final progressList = await _repository.getChallengeRanking(challengeId);
      
      // Mantém o estado atual
      final challenges = ChallengeStateHelper.getChallenges(state);
      final filteredChallenges = ChallengeStateHelper.getFilteredChallenges(state);
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(state);
      
      state = ChallengeState.success(
        challenges: challenges,
        filteredChallenges: filteredChallenges,
        selectedChallenge: selectedChallenge,
        progressList: progressList,
        message: 'Progresso atualizado com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Sanitiza uma string para evitar injeção e caracteres indesejados
  String _sanitizeString(String input) {
    // Remove caracteres HTML potencialmente perigosos
    var sanitized = input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&[^;]+;'), '')
        .trim();
    
    // Limita o tamanho da string a um valor razoável
    if (sanitized.length > 200) {
      sanitized = sanitized.substring(0, 200);
    }
    
    return sanitized;
  }
  
  /// Carrega o ranking de um desafio
  Future<void> loadChallengeRanking(String challengeId) async {
    try {
      state = const ChallengeState.loading();
      final progressList = await _repository.getChallengeRanking(challengeId);
      
      // Mantém o estado atual
      final challenges = ChallengeStateHelper.getChallenges(state);
      final filteredChallenges = ChallengeStateHelper.getFilteredChallenges(state);
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(state);
      
      state = ChallengeState.success(
        challenges: challenges,
        filteredChallenges: filteredChallenges,
        selectedChallenge: selectedChallenge,
        progressList: progressList,
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
  
  /// Limpa um erro
  void clearError() {
    state = const ChallengeState.initial();
  }
} 