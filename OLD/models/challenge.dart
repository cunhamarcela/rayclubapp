import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

/// Represents a challenge in the Ray Club application.
/// This model is immutable and uses Freezed for code generation.
@freezed
class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required int reward,
    required List<String> participants,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Challenge;

  /// Creates a Challenge from a JSON map
  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}
