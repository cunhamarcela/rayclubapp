import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/sub_challenge.dart';

part 'sub_challenge_state.freezed.dart';

/// Represents the state of a sub-challenge in the application.
/// This state is immutable and uses Freezed for code generation.
@freezed
class SubChallengeState with _$SubChallengeState {
  /// Initial state when the sub-challenge is first loaded
  const factory SubChallengeState.initial() = _Initial;

  /// State when loading sub-challenge data
  const factory SubChallengeState.loading() = _Loading;

  /// State when sub-challenge is loaded successfully
  const factory SubChallengeState.loaded({
    required SubChallenge subChallenge,
  }) = _Loaded;

  /// State when an error occurs
  const factory SubChallengeState.error({
    required String message,
  }) = _Error;
}
