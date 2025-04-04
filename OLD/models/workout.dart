import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout.freezed.dart';
part 'workout.g.dart';

/// Represents a workout in the Ray Club application.
/// This model is immutable and uses Freezed for code generation.
@freezed
class Workout with _$Workout {
  const factory Workout({
    required String id,
    required String title,
    required String description,
    String? imageUrl,
    required String type,
    required int durationMinutes,
    required String difficulty,
    required List<String> equipment,
    required Map<String, dynamic> exercises,
    required String creatorId,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Workout;

  /// Creates a Workout from a JSON map
  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);
}
