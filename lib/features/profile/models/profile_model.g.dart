// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      completedWorkouts: (json['completedWorkouts'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      points: (json['points'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      bio: json['bio'] as String?,
      goals:
          (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      favoriteWorkoutIds: (json['favoriteWorkoutIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      instagram: json['instagram'] as String?,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.name case final value?) 'name': value,
      if (instance.email case final value?) 'email': value,
      if (instance.photoUrl case final value?) 'photoUrl': value,
      'completedWorkouts': instance.completedWorkouts,
      'streak': instance.streak,
      'points': instance.points,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.bio case final value?) 'bio': value,
      'goals': instance.goals,
      'favoriteWorkoutIds': instance.favoriteWorkoutIds,
      if (instance.phone case final value?) 'phone': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.birthDate?.toIso8601String() case final value?)
        'birthDate': value,
      if (instance.instagram case final value?) 'instagram': value,
    };
