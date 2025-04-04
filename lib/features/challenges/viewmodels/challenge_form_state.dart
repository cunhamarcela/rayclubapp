import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/challenge.dart';

part 'challenge_form_state.freezed.dart';

@freezed
class ChallengeFormState with _$ChallengeFormState {
  const factory ChallengeFormState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    Challenge? challenge,
    @Default('') String title,
    @Default('') String description,
    @Default('') String reward,
    @Default('') String imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    String? error,
  }) = _ChallengeFormState;
  
  factory ChallengeFormState.initial() => ChallengeFormState(
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
  );
  
  factory ChallengeFormState.fromChallenge(Challenge challenge) => ChallengeFormState(
    challenge: challenge,
    title: challenge.title,
    description: challenge.description,
    reward: challenge.reward.toString(),
    imageUrl: challenge.imageUrl ?? '',
    startDate: challenge.startDate,
    endDate: challenge.endDate,
  );
} 