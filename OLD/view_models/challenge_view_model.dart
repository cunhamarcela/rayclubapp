import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/challenge.dart';
import '../repositories/challenge_repository.dart';
import '../core/exceptions/repository_exception.dart';
import '../core/providers/providers.dart';

part 'challenge_view_model.freezed.dart';

/// State for the challenge view model
@freezed
class ChallengeState with _$ChallengeState {
  /// Default state with parameters
  const factory ChallengeState({
    @Default([]) List<Challenge> challenges,
    @Default([]) List<Challenge> filteredChallenges,
    Challenge? selectedChallenge,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
  }) = _ChallengeState;

  /// Initial state
  const factory ChallengeState.initial() = _Initial;

  /// Loading state
  const factory ChallengeState.loading() = _Loading;

  /// Success state with data
  const factory ChallengeState.success({
    required List<Challenge> challenges,
    @Default([]) List<Challenge> filteredChallenges,
    Challenge? selectedChallenge,
    String? message,
  }) = _Success;

  /// Error state
  const factory ChallengeState.error({
    required String message,
  }) = _Error;
}

/// Provider for the challenge view model
final challengeViewModelProvider = StateNotifierProvider<ChallengeViewModel, ChallengeState>((ref) {
  final repository = ref.watch(challengeRepositoryProvider);
  return ChallengeViewModel(repository: repository);
});

/// ViewModel for managing challenges
class ChallengeViewModel extends StateNotifier<ChallengeState> {
  final IChallengeRepository _repository;

  ChallengeViewModel({required IChallengeRepository repository})
      : _repository = repository,
        super(const ChallengeState.initial()) {
    loadChallenges();
  }

  /// Extracts error message from an exception
  String _getErrorMessage(dynamic error) {
    if (error is RepositoryException) {
      return error.message;
    }
    return error.toString();
  }

  /// Loads all challenges from the repository
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

  /// Loads challenges created by a specific user
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

  /// Loads active challenges (those that have not ended yet)
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

  /// Loads the main challenge (featured challenge)
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

  /// Get details for a specific challenge
  Future<void> getChallengeDetails(String challengeId) async {
    try {
      state = const ChallengeState.loading();
      final challenge = await _repository.getChallengeById(challengeId);
      
      // Keep current challenges list
      final currentChallenges = state.maybeWhen(
        success: (challenges, _, __, ___) => challenges,
        orElse: () => <Challenge>[],
      );
      
      state = ChallengeState.success(
        challenges: currentChallenges,
        filteredChallenges: currentChallenges,
        selectedChallenge: challenge,
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Creates a new challenge
  Future<void> createChallenge(Challenge challenge) async {
    try {
      state = const ChallengeState.loading();
      final newChallenge = await _repository.createChallenge(challenge);
      
      // Keep current challenges list and add the new one
      final currentChallenges = state.maybeWhen(
        success: (challenges, _, __, ___) => challenges,
        orElse: () => <Challenge>[],
      );
      
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

  /// Updates an existing challenge
  Future<void> updateChallenge(Challenge challenge) async {
    try {
      state = const ChallengeState.loading();
      await _repository.updateChallenge(challenge);
      
      // Keep current challenges list and update the modified one
      final currentChallenges = state.maybeWhen(
        success: (challenges, _, __, ___) => challenges,
        orElse: () => <Challenge>[],
      );
      
      final updatedChallenges = currentChallenges.map((c) {
        return c.id == challenge.id ? challenge : c;
      }).toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: challenge,
        message: 'Desafio atualizado com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Joins a challenge for a user
  Future<void> joinChallenge({
    required String challengeId,
    required String userId,
  }) async {
    try {
      state = const ChallengeState.loading();
      await _repository.joinChallenge(challengeId: challengeId, userId: userId);
      
      // Get updated challenge details after joining
      final updatedChallenge = await _repository.getChallengeById(challengeId);
      
      // Keep current challenges list and update the modified one
      final currentChallenges = state.maybeWhen(
        success: (challenges, _, __, ___) => challenges,
        orElse: () => <Challenge>[],
      );
      
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

  /// Leaves a challenge for a user
  Future<void> leaveChallenge({
    required String challengeId,
    required String userId,
  }) async {
    try {
      state = const ChallengeState.loading();
      await _repository.leaveChallenge(challengeId: challengeId, userId: userId);
      
      // Get updated challenge details after leaving
      final updatedChallenge = await _repository.getChallengeById(challengeId);
      
      // Keep current challenges list and update the modified one
      final currentChallenges = state.maybeWhen(
        success: (challenges, _, __, ___) => challenges,
        orElse: () => <Challenge>[],
      );
      
      final updatedChallenges = currentChallenges.map((c) {
        return c.id == challengeId ? updatedChallenge : c;
      }).toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        selectedChallenge: updatedChallenge,
        message: 'Você saiu do desafio!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }

  /// Deletes a challenge
  Future<void> deleteChallenge(String challengeId) async {
    try {
      state = const ChallengeState.loading();
      await _repository.deleteChallenge(challengeId);
      
      // Keep current challenges list and remove the deleted one
      final currentChallenges = state.maybeWhen(
        success: (challenges, _, __, ___) => challenges,
        orElse: () => <Challenge>[],
      );
      
      final updatedChallenges = currentChallenges
          .where((c) => c.id != challengeId)
          .toList();
      
      state = ChallengeState.success(
        challenges: updatedChallenges,
        filteredChallenges: updatedChallenges,
        message: 'Desafio excluído com sucesso!',
      );
    } catch (e) {
      state = ChallengeState.error(message: _getErrorMessage(e));
    }
  }
}
