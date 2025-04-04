// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubChallengeImpl _$$SubChallengeImplFromJson(Map<String, dynamic> json) =>
    _$SubChallengeImpl(
      id: json['id'] as String,
      parentChallengeId: json['parentChallengeId'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      criteria: json['criteria'] as Map<String, dynamic>,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status:
          $enumDecodeNullable(_$SubChallengeStatusEnumMap, json['status']) ??
              SubChallengeStatus.active,
      validationRules:
          json['validationRules'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SubChallengeImplToJson(_$SubChallengeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentChallengeId': instance.parentChallengeId,
      'creatorId': instance.creatorId,
      'title': instance.title,
      'description': instance.description,
      'criteria': instance.criteria,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'participants': instance.participants,
      'status': _$SubChallengeStatusEnumMap[instance.status]!,
      'validationRules': instance.validationRules,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SubChallengeStatusEnumMap = {
  SubChallengeStatus.active: 'active',
  SubChallengeStatus.completed: 'completed',
  SubChallengeStatus.expired: 'expired',
  SubChallengeStatus.moderated: 'moderated',
};
