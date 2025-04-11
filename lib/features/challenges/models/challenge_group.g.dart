// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChallengeGroupImpl _$$ChallengeGroupImplFromJson(Map<String, dynamic> json) =>
    _$ChallengeGroupImpl(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      creatorId: json['creatorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      memberIds: (json['memberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pendingInviteIds: (json['pendingInviteIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChallengeGroupImplToJson(
        _$ChallengeGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challengeId': instance.challengeId,
      'creatorId': instance.creatorId,
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      'memberIds': instance.memberIds,
      'pendingInviteIds': instance.pendingInviteIds,
      'createdAt': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

_$ChallengeGroupInviteImpl _$$ChallengeGroupInviteImplFromJson(
        Map<String, dynamic> json) =>
    _$ChallengeGroupInviteImpl(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      inviterId: json['inviterId'] as String,
      inviterName: json['inviterName'] as String,
      inviteeId: json['inviteeId'] as String,
      status: $enumDecodeNullable(_$InviteStatusEnumMap, json['status']) ??
          InviteStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$ChallengeGroupInviteImplToJson(
        _$ChallengeGroupInviteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'inviterId': instance.inviterId,
      'inviterName': instance.inviterName,
      'inviteeId': instance.inviteeId,
      'status': _$InviteStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      if (instance.respondedAt?.toIso8601String() case final value?)
        'respondedAt': value,
    };

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
