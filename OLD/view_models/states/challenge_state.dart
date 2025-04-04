import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/challenge.dart';

part 'challenge_state.freezed.dart';

/// Represents the state of a challenge in the application.
/// This state is immutable and uses Freezed for code generation.
@freezed
class ChallengeState with _$ChallengeState {
  /// Initial state when the challenge is first loaded
  const factory ChallengeState.initial() = _Initial;

  /// State when loading challenge data
  const factory ChallengeState.loading() = _Loading;

  /// State when challenge is loaded successfully
  const factory ChallengeState.loaded({
    required Challenge challenge,
  }) = _Loaded;

  /// State when an error occurs
  const factory ChallengeState.error({
    required String message,
  }) = _Error;
}
