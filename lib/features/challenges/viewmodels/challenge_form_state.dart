// Package imports:
// import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../models/challenge.dart';

// part 'challenge_form_state.freezed.dart';

class ChallengeFormState {
  final bool isLoading;
  final bool isSaving;
  final Challenge? challenge;
  final String title;
  final String description;
  final String reward;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String? error;

  const ChallengeFormState({
    this.isLoading = false,
    this.isSaving = false,
    this.challenge,
    this.title = '',
    this.description = '',
    this.reward = '',
    this.imageUrl = '',
    required this.startDate,
    required this.endDate,
    this.error,
  });
  
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

  ChallengeFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    Challenge? challenge,
    String? title,
    String? description,
    String? reward,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? error,
  }) {
    return ChallengeFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      challenge: challenge ?? this.challenge,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      error: error ?? this.error,
    );
  }
} 
