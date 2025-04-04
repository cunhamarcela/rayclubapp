import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../repositories/challenge_repository.dart';
import '../repositories/workout_repository.dart';
import '../models/challenge.dart';
import '../models/workout.dart';
import '../core/providers/providers.dart';

part 'home_view_model.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Challenge> challenges,
    @Default([]) List<Workout> workouts,
    @Default(false) bool isLoading,
    String? error,
  }) = _HomeState;
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(
    challengeRepository: ref.watch(challengeRepositoryProvider),
    workoutRepository: ref.watch(workoutRepositoryProvider),
  );
});

class HomeViewModel extends StateNotifier<HomeState> {
  final IChallengeRepository _challengeRepository;
  final IWorkoutRepository _workoutRepository;

  HomeViewModel({
    required IChallengeRepository challengeRepository,
    required IWorkoutRepository workoutRepository,
  })  : _challengeRepository = challengeRepository,
        _workoutRepository = workoutRepository,
        super(const HomeState()) {
    initialize();
  }

  Future<void> initialize() async {
    await Future.wait([
      _loadChallenges(),
      _loadWorkouts(),
    ]);
  }

  Future<void> _loadChallenges() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final challenges = await _challengeRepository.getChallenges();
      state = state.copyWith(
        challenges: challenges,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _loadWorkouts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final workouts = await _workoutRepository.getWorkouts();
      state = state.copyWith(
        workouts: workouts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createChallenge(Challenge challenge) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _challengeRepository.createChallenge(challenge);
      await _loadChallenges();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> joinChallenge(String challengeId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final challenge = state.challenges.firstWhere((c) => c.id == challengeId);

      // Create updated challenge with current user added to participants
      final updatedChallenge = challenge.copyWith(
        participants: [...challenge.participants],
        updatedAt: DateTime.now(),
      );

      // Update the challenge in the repository
      await _challengeRepository.updateChallenge(
        challengeId,
        updatedChallenge.toJson(),
      );

      // Refresh the challenges list
      await _loadChallenges();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshData() async {
    await initialize();
  }
}
