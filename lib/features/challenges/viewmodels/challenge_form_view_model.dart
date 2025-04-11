// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:ray_club_app/core/errors/app_exception.dart';
import '../../../core/providers/providers.dart';
import '../../../features/auth/repositories/auth_repository.dart';
import '../models/challenge.dart';
import '../repositories/challenge_repository.dart';
import 'challenge_form_state.dart';

final challengeFormViewModelProvider = StateNotifierProvider.autoDispose<ChallengeFormViewModel, ChallengeFormState>((ref) {
  final repository = ref.watch(challengeRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return ChallengeFormViewModel(repository, authRepository);
});

class ChallengeFormViewModel extends StateNotifier<ChallengeFormState> {
  final ChallengeRepository _repository;
  final IAuthRepository _authRepository;

  ChallengeFormViewModel(this._repository, this._authRepository) 
      : super(ChallengeFormState.initial());

  // Carrega os detalhes de um desafio existente
  Future<void> loadChallenge(String challengeId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final challenge = await _repository.getChallengeById(challengeId);
      state = ChallengeFormState.fromChallenge(challenge);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar desafio: ${e.toString()}',
      );
    }
  }

  // Atualiza o título do desafio
  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  // Atualiza a descrição do desafio
  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  // Atualiza a recompensa do desafio
  void updateReward(String reward) {
    state = state.copyWith(reward: reward);
  }

  // Atualiza a URL da imagem do desafio
  void updateImageUrl(String imageUrl) {
    state = state.copyWith(imageUrl: imageUrl);
  }

  // Atualiza a data de início do desafio
  void updateStartDate(DateTime startDate) {
    DateTime endDate = state.endDate;
    
    // Se a data de início for posterior à data de término, atualiza a data de término
    if (startDate.isAfter(endDate)) {
      endDate = startDate.add(const Duration(days: 7));
    }
    
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  // Atualiza a data de término do desafio
  void updateEndDate(DateTime endDate) {
    // Certifica-se de que a data de término não é anterior à data de início
    if (endDate.isBefore(state.startDate)) {
      throw ValidationException(
        message: 'A data de término não pode ser anterior à data de início',
      );
    }
    
    state = state.copyWith(endDate: endDate);
  }

  // Salva o desafio (cria um novo ou atualiza um existente)
  Future<void> saveChallenge() async {
    // Valida os dados do formulário
    if (state.title.isEmpty) {
      state = state.copyWith(error: 'O título é obrigatório');
      return;
    }
    
    if (state.description.isEmpty) {
      state = state.copyWith(error: 'A descrição é obrigatória');
      return;
    }
    
    // Valida a recompensa como um número inteiro
    int? reward;
    try {
      reward = int.parse(state.reward);
      if (reward < 0) {
        state = state.copyWith(error: 'A recompensa não pode ser negativa');
        return;
      }
    } catch (_) {
      state = state.copyWith(error: 'A recompensa deve ser um número');
      return;
    }
    
    state = state.copyWith(isSaving: true, error: null);
    
    try {
      final imageUrl = state.imageUrl.isNotEmpty ? state.imageUrl : null;
      
      // Obtém o usuário atual
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        throw AppAuthException(message: 'Usuário não autenticado');
      }
      
      if (state.challenge != null) {
        // Atualiza o desafio existente
        final updatedChallenge = state.challenge!.copyWith(
          title: state.title,
          description: state.description,
          points: reward,
          imageUrl: imageUrl,
          startDate: state.startDate,
          endDate: state.endDate,
          updatedAt: DateTime.now(),
        );
        
        await _repository.updateChallenge(updatedChallenge);
      } else {
        // Cria um novo desafio
        final newChallenge = Challenge(
          id: '', // Será gerado pelo repositório
          title: state.title,
          description: state.description,
          points: reward,
          imageUrl: imageUrl,
          startDate: state.startDate,
          endDate: state.endDate,
          participants: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          creatorId: currentUser.id,
        );
        
        await _repository.createChallenge(newChallenge);
      }
      
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Erro ao salvar desafio: ${e.toString()}',
      );
    }
  }
} 
