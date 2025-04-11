// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChallengeGroup _$ChallengeGroupFromJson(Map<String, dynamic> json) {
  return _ChallengeGroup.fromJson(json);
}

/// @nodoc
mixin _$ChallengeGroup {
  /// ID único do grupo
  String get id => throw _privateConstructorUsedError;

  /// ID do desafio principal ao qual este grupo pertence
  String get challengeId => throw _privateConstructorUsedError;

  /// ID do usuário que criou o grupo
  String get creatorId => throw _privateConstructorUsedError;

  /// Nome do grupo
  String get name => throw _privateConstructorUsedError;

  /// Descrição opcional do grupo
  String? get description => throw _privateConstructorUsedError;

  /// Lista de IDs dos membros do grupo (incluindo o criador)
  List<String> get memberIds => throw _privateConstructorUsedError;

  /// Lista de IDs dos usuários convidados pendentes
  List<String> get pendingInviteIds => throw _privateConstructorUsedError;

  /// Data de criação do grupo
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Data da última atualização do grupo
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChallengeGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChallengeGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChallengeGroupCopyWith<ChallengeGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeGroupCopyWith<$Res> {
  factory $ChallengeGroupCopyWith(
          ChallengeGroup value, $Res Function(ChallengeGroup) then) =
      _$ChallengeGroupCopyWithImpl<$Res, ChallengeGroup>;
  @useResult
  $Res call(
      {String id,
      String challengeId,
      String creatorId,
      String name,
      String? description,
      List<String> memberIds,
      List<String> pendingInviteIds,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ChallengeGroupCopyWithImpl<$Res, $Val extends ChallengeGroup>
    implements $ChallengeGroupCopyWith<$Res> {
  _$ChallengeGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChallengeGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? challengeId = null,
    Object? creatorId = null,
    Object? name = null,
    Object? description = freezed,
    Object? memberIds = null,
    Object? pendingInviteIds = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      challengeId: null == challengeId
          ? _value.challengeId
          : challengeId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      memberIds: null == memberIds
          ? _value.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingInviteIds: null == pendingInviteIds
          ? _value.pendingInviteIds
          : pendingInviteIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChallengeGroupImplCopyWith<$Res>
    implements $ChallengeGroupCopyWith<$Res> {
  factory _$$ChallengeGroupImplCopyWith(_$ChallengeGroupImpl value,
          $Res Function(_$ChallengeGroupImpl) then) =
      __$$ChallengeGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String challengeId,
      String creatorId,
      String name,
      String? description,
      List<String> memberIds,
      List<String> pendingInviteIds,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ChallengeGroupImplCopyWithImpl<$Res>
    extends _$ChallengeGroupCopyWithImpl<$Res, _$ChallengeGroupImpl>
    implements _$$ChallengeGroupImplCopyWith<$Res> {
  __$$ChallengeGroupImplCopyWithImpl(
      _$ChallengeGroupImpl _value, $Res Function(_$ChallengeGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? challengeId = null,
    Object? creatorId = null,
    Object? name = null,
    Object? description = freezed,
    Object? memberIds = null,
    Object? pendingInviteIds = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChallengeGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      challengeId: null == challengeId
          ? _value.challengeId
          : challengeId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      memberIds: null == memberIds
          ? _value._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingInviteIds: null == pendingInviteIds
          ? _value._pendingInviteIds
          : pendingInviteIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChallengeGroupImpl extends _ChallengeGroup {
  const _$ChallengeGroupImpl(
      {required this.id,
      required this.challengeId,
      required this.creatorId,
      required this.name,
      this.description,
      final List<String> memberIds = const [],
      final List<String> pendingInviteIds = const [],
      required this.createdAt,
      this.updatedAt})
      : _memberIds = memberIds,
        _pendingInviteIds = pendingInviteIds,
        super._();

  factory _$ChallengeGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChallengeGroupImplFromJson(json);

  /// ID único do grupo
  @override
  final String id;

  /// ID do desafio principal ao qual este grupo pertence
  @override
  final String challengeId;

  /// ID do usuário que criou o grupo
  @override
  final String creatorId;

  /// Nome do grupo
  @override
  final String name;

  /// Descrição opcional do grupo
  @override
  final String? description;

  /// Lista de IDs dos membros do grupo (incluindo o criador)
  final List<String> _memberIds;

  /// Lista de IDs dos membros do grupo (incluindo o criador)
  @override
  @JsonKey()
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  /// Lista de IDs dos usuários convidados pendentes
  final List<String> _pendingInviteIds;

  /// Lista de IDs dos usuários convidados pendentes
  @override
  @JsonKey()
  List<String> get pendingInviteIds {
    if (_pendingInviteIds is EqualUnmodifiableListView)
      return _pendingInviteIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingInviteIds);
  }

  /// Data de criação do grupo
  @override
  final DateTime createdAt;

  /// Data da última atualização do grupo
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChallengeGroup(id: $id, challengeId: $challengeId, creatorId: $creatorId, name: $name, description: $description, memberIds: $memberIds, pendingInviteIds: $pendingInviteIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.challengeId, challengeId) ||
                other.challengeId == challengeId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            const DeepCollectionEquality()
                .equals(other._pendingInviteIds, _pendingInviteIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      challengeId,
      creatorId,
      name,
      description,
      const DeepCollectionEquality().hash(_memberIds),
      const DeepCollectionEquality().hash(_pendingInviteIds),
      createdAt,
      updatedAt);

  /// Create a copy of ChallengeGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeGroupImplCopyWith<_$ChallengeGroupImpl> get copyWith =>
      __$$ChallengeGroupImplCopyWithImpl<_$ChallengeGroupImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChallengeGroupImplToJson(
      this,
    );
  }
}

abstract class _ChallengeGroup extends ChallengeGroup {
  const factory _ChallengeGroup(
      {required final String id,
      required final String challengeId,
      required final String creatorId,
      required final String name,
      final String? description,
      final List<String> memberIds,
      final List<String> pendingInviteIds,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ChallengeGroupImpl;
  const _ChallengeGroup._() : super._();

  factory _ChallengeGroup.fromJson(Map<String, dynamic> json) =
      _$ChallengeGroupImpl.fromJson;

  /// ID único do grupo
  @override
  String get id;

  /// ID do desafio principal ao qual este grupo pertence
  @override
  String get challengeId;

  /// ID do usuário que criou o grupo
  @override
  String get creatorId;

  /// Nome do grupo
  @override
  String get name;

  /// Descrição opcional do grupo
  @override
  String? get description;

  /// Lista de IDs dos membros do grupo (incluindo o criador)
  @override
  List<String> get memberIds;

  /// Lista de IDs dos usuários convidados pendentes
  @override
  List<String> get pendingInviteIds;

  /// Data de criação do grupo
  @override
  DateTime get createdAt;

  /// Data da última atualização do grupo
  @override
  DateTime? get updatedAt;

  /// Create a copy of ChallengeGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChallengeGroupImplCopyWith<_$ChallengeGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChallengeGroupInvite _$ChallengeGroupInviteFromJson(Map<String, dynamic> json) {
  return _ChallengeGroupInvite.fromJson(json);
}

/// @nodoc
mixin _$ChallengeGroupInvite {
  /// ID único do convite
  String get id => throw _privateConstructorUsedError;

  /// ID do grupo para o qual o usuário está sendo convidado
  String get groupId => throw _privateConstructorUsedError;

  /// Nome do grupo (para exibição)
  String get groupName => throw _privateConstructorUsedError;

  /// ID do usuário que está convidando
  String get inviterId => throw _privateConstructorUsedError;

  /// Nome do usuário que está convidando (para exibição)
  String get inviterName => throw _privateConstructorUsedError;

  /// ID do usuário que está sendo convidado
  String get inviteeId => throw _privateConstructorUsedError;

  /// Status do convite (pendente, aceito, recusado)
  InviteStatus get status => throw _privateConstructorUsedError;

  /// Data de criação do convite
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Data de resposta do convite (quando aceito ou recusado)
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this ChallengeGroupInvite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChallengeGroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChallengeGroupInviteCopyWith<ChallengeGroupInvite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeGroupInviteCopyWith<$Res> {
  factory $ChallengeGroupInviteCopyWith(ChallengeGroupInvite value,
          $Res Function(ChallengeGroupInvite) then) =
      _$ChallengeGroupInviteCopyWithImpl<$Res, ChallengeGroupInvite>;
  @useResult
  $Res call(
      {String id,
      String groupId,
      String groupName,
      String inviterId,
      String inviterName,
      String inviteeId,
      InviteStatus status,
      DateTime createdAt,
      DateTime? respondedAt});
}

/// @nodoc
class _$ChallengeGroupInviteCopyWithImpl<$Res,
        $Val extends ChallengeGroupInvite>
    implements $ChallengeGroupInviteCopyWith<$Res> {
  _$ChallengeGroupInviteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChallengeGroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? groupName = null,
    Object? inviterId = null,
    Object? inviterName = null,
    Object? inviteeId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      inviterId: null == inviterId
          ? _value.inviterId
          : inviterId // ignore: cast_nullable_to_non_nullable
              as String,
      inviterName: null == inviterName
          ? _value.inviterName
          : inviterName // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeId: null == inviteeId
          ? _value.inviteeId
          : inviteeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InviteStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChallengeGroupInviteImplCopyWith<$Res>
    implements $ChallengeGroupInviteCopyWith<$Res> {
  factory _$$ChallengeGroupInviteImplCopyWith(_$ChallengeGroupInviteImpl value,
          $Res Function(_$ChallengeGroupInviteImpl) then) =
      __$$ChallengeGroupInviteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String groupId,
      String groupName,
      String inviterId,
      String inviterName,
      String inviteeId,
      InviteStatus status,
      DateTime createdAt,
      DateTime? respondedAt});
}

/// @nodoc
class __$$ChallengeGroupInviteImplCopyWithImpl<$Res>
    extends _$ChallengeGroupInviteCopyWithImpl<$Res, _$ChallengeGroupInviteImpl>
    implements _$$ChallengeGroupInviteImplCopyWith<$Res> {
  __$$ChallengeGroupInviteImplCopyWithImpl(_$ChallengeGroupInviteImpl _value,
      $Res Function(_$ChallengeGroupInviteImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeGroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? groupName = null,
    Object? inviterId = null,
    Object? inviterName = null,
    Object? inviteeId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
  }) {
    return _then(_$ChallengeGroupInviteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      inviterId: null == inviterId
          ? _value.inviterId
          : inviterId // ignore: cast_nullable_to_non_nullable
              as String,
      inviterName: null == inviterName
          ? _value.inviterName
          : inviterName // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeId: null == inviteeId
          ? _value.inviteeId
          : inviteeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InviteStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChallengeGroupInviteImpl implements _ChallengeGroupInvite {
  const _$ChallengeGroupInviteImpl(
      {required this.id,
      required this.groupId,
      required this.groupName,
      required this.inviterId,
      required this.inviterName,
      required this.inviteeId,
      this.status = InviteStatus.pending,
      required this.createdAt,
      this.respondedAt});

  factory _$ChallengeGroupInviteImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChallengeGroupInviteImplFromJson(json);

  /// ID único do convite
  @override
  final String id;

  /// ID do grupo para o qual o usuário está sendo convidado
  @override
  final String groupId;

  /// Nome do grupo (para exibição)
  @override
  final String groupName;

  /// ID do usuário que está convidando
  @override
  final String inviterId;

  /// Nome do usuário que está convidando (para exibição)
  @override
  final String inviterName;

  /// ID do usuário que está sendo convidado
  @override
  final String inviteeId;

  /// Status do convite (pendente, aceito, recusado)
  @override
  @JsonKey()
  final InviteStatus status;

  /// Data de criação do convite
  @override
  final DateTime createdAt;

  /// Data de resposta do convite (quando aceito ou recusado)
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'ChallengeGroupInvite(id: $id, groupId: $groupId, groupName: $groupName, inviterId: $inviterId, inviterName: $inviterName, inviteeId: $inviteeId, status: $status, createdAt: $createdAt, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeGroupInviteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.inviterId, inviterId) ||
                other.inviterId == inviterId) &&
            (identical(other.inviterName, inviterName) ||
                other.inviterName == inviterName) &&
            (identical(other.inviteeId, inviteeId) ||
                other.inviteeId == inviteeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, groupId, groupName,
      inviterId, inviterName, inviteeId, status, createdAt, respondedAt);

  /// Create a copy of ChallengeGroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeGroupInviteImplCopyWith<_$ChallengeGroupInviteImpl>
      get copyWith =>
          __$$ChallengeGroupInviteImplCopyWithImpl<_$ChallengeGroupInviteImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChallengeGroupInviteImplToJson(
      this,
    );
  }
}

abstract class _ChallengeGroupInvite implements ChallengeGroupInvite {
  const factory _ChallengeGroupInvite(
      {required final String id,
      required final String groupId,
      required final String groupName,
      required final String inviterId,
      required final String inviterName,
      required final String inviteeId,
      final InviteStatus status,
      required final DateTime createdAt,
      final DateTime? respondedAt}) = _$ChallengeGroupInviteImpl;

  factory _ChallengeGroupInvite.fromJson(Map<String, dynamic> json) =
      _$ChallengeGroupInviteImpl.fromJson;

  /// ID único do convite
  @override
  String get id;

  /// ID do grupo para o qual o usuário está sendo convidado
  @override
  String get groupId;

  /// Nome do grupo (para exibição)
  @override
  String get groupName;

  /// ID do usuário que está convidando
  @override
  String get inviterId;

  /// Nome do usuário que está convidando (para exibição)
  @override
  String get inviterName;

  /// ID do usuário que está sendo convidado
  @override
  String get inviteeId;

  /// Status do convite (pendente, aceito, recusado)
  @override
  InviteStatus get status;

  /// Data de criação do convite
  @override
  DateTime get createdAt;

  /// Data de resposta do convite (quando aceito ou recusado)
  @override
  DateTime? get respondedAt;

  /// Create a copy of ChallengeGroupInvite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChallengeGroupInviteImplCopyWith<_$ChallengeGroupInviteImpl>
      get copyWith => throw _privateConstructorUsedError;
}
