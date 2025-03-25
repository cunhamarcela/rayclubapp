// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutImpl _$$WorkoutImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      equipment:
          (json['equipment'] as List<dynamic>).map((e) => e as String).toList(),
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => WorkoutSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      creatorId: json['creatorId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkoutImplToJson(_$WorkoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'durationMinutes': instance.durationMinutes,
      'difficulty': instance.difficulty,
      'equipment': instance.equipment,
      'sections': instance.sections,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      name: json['name'] as String,
      description: json['description'] as String?,
      sets: (json['sets'] as num?)?.toInt() ?? 3,
      reps: (json['reps'] as num?)?.toInt() ?? 12,
      restSeconds: (json['restSeconds'] as num?)?.toInt() ?? 60,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'sets': instance.sets,
      'reps': instance.reps,
      'restSeconds': instance.restSeconds,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
    };

_$WorkoutSectionImpl _$$WorkoutSectionImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSectionImpl(
      name: json['name'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkoutSectionImplToJson(
        _$WorkoutSectionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exercises': instance.exercises,
    };

_$WorkoutFilterImpl _$$WorkoutFilterImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutFilterImpl(
      category: json['category'] as String? ?? '',
      maxDuration: (json['maxDuration'] as num?)?.toInt() ?? 0,
      difficulty: json['difficulty'] as String? ?? '',
    );

Map<String, dynamic> _$$WorkoutFilterImplToJson(_$WorkoutFilterImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'maxDuration': instance.maxDuration,
      'difficulty': instance.difficulty,
    };
