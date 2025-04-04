import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/providers.dart';
import '../repositories/sub_challenge_repository.dart';
import '../services/storage_service.dart';
import '../models/sub_challenge.dart';
import 'states/sub_challenge_state.dart';

final subChallengeViewModelProvider = StateNotifierProvider.family<
    SubChallengeViewModel, SubChallengeState, String>(
  (ref, subChallengeId) => SubChallengeViewModel(
    subChallengeRepository: ref.read(subChallengeRepositoryProvider),
    storageService: ref.read(storageServiceProvider),
    subChallengeId: subChallengeId,
  ),
);

/// ViewModel responsible for handling sub-challenge-related operations.
class SubChallengeViewModel extends StateNotifier<SubChallengeState> {
  final ISubChallengeRepository subChallengeRepository;
  final StorageService storageService;
  final String subChallengeId;

  SubChallengeViewModel({
    required this.subChallengeRepository,
    required this.storageService,
    required this.subChallengeId,
  }) : super(const SubChallengeState.initial()) {
    initialize(subChallengeId);
  }

  /// Initializes the view model by loading the sub-challenge data
  Future<void> initialize(String id) async {
    try {
      state = const SubChallengeState.loading();
      final subChallenge = await subChallengeRepository.getSubChallenge(id);
      state = SubChallengeState.loaded(subChallenge: subChallenge);
    } catch (e) {
      state = SubChallengeState.error(message: e.toString());
    }
  }

  /// Updates the sub-challenge with new data
  Future<void> updateSubChallenge({
    required String id,
    required SubChallenge subChallenge,
  }) async {
    try {
      state = const SubChallengeState.loading();
      final updatedSubChallenge = await subChallengeRepository
          .updateSubChallenge(id, subChallenge.toJson());
      state = SubChallengeState.loaded(subChallenge: updatedSubChallenge);
    } catch (e) {
      state = SubChallengeState.error(message: e.toString());
    }
  }

  /// Deletes the sub-challenge
  Future<void> deleteSubChallenge(String id) async {
    try {
      state = const SubChallengeState.loading();
      await subChallengeRepository.deleteSubChallenge(id);
      state = const SubChallengeState.initial();
    } catch (e) {
      state = SubChallengeState.error(message: e.toString());
    }
  }

  /// Validates user participation in the sub-challenge
  Future<void> validateParticipation(String userId) async {
    try {
      state = const SubChallengeState.loading();
      await subChallengeRepository.validateParticipation(
          userId, subChallengeId);
      await initialize(subChallengeId); // Reload data
    } catch (e) {
      state = SubChallengeState.error(message: e.toString());
    }
  }

  /// Moderates the sub-challenge
  Future<void> moderateSubChallenge(ModerationType action) async {
    try {
      state = const SubChallengeState.loading();
      await subChallengeRepository.moderateSubChallenge(subChallengeId, action);
      await initialize(subChallengeId); // Reload data
    } catch (e) {
      state = SubChallengeState.error(message: e.toString());
    }
  }
}
