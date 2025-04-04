import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_challenge.freezed.dart';
part 'sub_challenge.g.dart';

/// Status do sub-desafio
enum SubChallengeStatus { active, completed, expired, moderated }

/// Represents a sub-challenge in the Ray Club application.
/// This model is immutable and uses Freezed for code generation.
@freezed
class SubChallenge with _$SubChallenge {
  const factory SubChallenge({
    required String id,
    required String parentChallengeId,
    required String creatorId,
    required String title,
    required String description,
    required Map<String, dynamic> criteria,
    required DateTime startDate,
    required DateTime endDate,
    @Default([]) List<String> participants,
    @Default(SubChallengeStatus.active) SubChallengeStatus status,
    @Default({}) Map<String, dynamic> validationRules,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _SubChallenge;

  /// Creates a SubChallenge from a JSON map
  factory SubChallenge.fromJson(Map<String, dynamic> json) =>
      _$SubChallengeFromJson(json);
}
