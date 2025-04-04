// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubChallenge _$SubChallengeFromJson(Map<String, dynamic> json) {
  return _SubChallenge.fromJson(json);
}

/// @nodoc
mixin _$SubChallenge {
  String get id => throw _privateConstructorUsedError;
  String get parentChallengeId => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get criteria => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;
  SubChallengeStatus get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get validationRules =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SubChallenge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubChallengeCopyWith<SubChallenge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubChallengeCopyWith<$Res> {
  factory $SubChallengeCopyWith(
          SubChallenge value, $Res Function(SubChallenge) then) =
      _$SubChallengeCopyWithImpl<$Res, SubChallenge>;
  @useResult
  $Res call(
      {String id,
      String parentChallengeId,
      String creatorId,
      String title,
      String description,
      Map<String, dynamic> criteria,
      DateTime startDate,
      DateTime endDate,
      List<String> participants,
      SubChallengeStatus status,
      Map<String, dynamic> validationRules,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$SubChallengeCopyWithImpl<$Res, $Val extends SubChallenge>
    implements $SubChallengeCopyWith<$Res> {
  _$SubChallengeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentChallengeId = null,
    Object? creatorId = null,
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? participants = null,
    Object? status = null,
    Object? validationRules = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentChallengeId: null == parentChallengeId
          ? _value.parentChallengeId
          : parentChallengeId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubChallengeStatus,
      validationRules: null == validationRules
          ? _value.validationRules
          : validationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
abstract class _$$SubChallengeImplCopyWith<$Res>
    implements $SubChallengeCopyWith<$Res> {
  factory _$$SubChallengeImplCopyWith(
          _$SubChallengeImpl value, $Res Function(_$SubChallengeImpl) then) =
      __$$SubChallengeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String parentChallengeId,
      String creatorId,
      String title,
      String description,
      Map<String, dynamic> criteria,
      DateTime startDate,
      DateTime endDate,
      List<String> participants,
      SubChallengeStatus status,
      Map<String, dynamic> validationRules,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SubChallengeImplCopyWithImpl<$Res>
    extends _$SubChallengeCopyWithImpl<$Res, _$SubChallengeImpl>
    implements _$$SubChallengeImplCopyWith<$Res> {
  __$$SubChallengeImplCopyWithImpl(
      _$SubChallengeImpl _value, $Res Function(_$SubChallengeImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubChallenge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentChallengeId = null,
    Object? creatorId = null,
    Object? title = null,
    Object? description = null,
    Object? criteria = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? participants = null,
    Object? status = null,
    Object? validationRules = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SubChallengeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentChallengeId: null == parentChallengeId
          ? _value.parentChallengeId
          : parentChallengeId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      criteria: null == criteria
          ? _value._criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubChallengeStatus,
      validationRules: null == validationRules
          ? _value._validationRules
          : validationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
class _$SubChallengeImpl implements _SubChallenge {
  const _$SubChallengeImpl(
      {required this.id,
      required this.parentChallengeId,
      required this.creatorId,
      required this.title,
      required this.description,
      required final Map<String, dynamic> criteria,
      required this.startDate,
      required this.endDate,
      final List<String> participants = const [],
      this.status = SubChallengeStatus.active,
      final Map<String, dynamic> validationRules = const {},
      required this.createdAt,
      this.updatedAt})
      : _criteria = criteria,
        _participants = participants,
        _validationRules = validationRules;

  factory _$SubChallengeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubChallengeImplFromJson(json);

  @override
  final String id;
  @override
  final String parentChallengeId;
  @override
  final String creatorId;
  @override
  final String title;
  @override
  final String description;
  final Map<String, dynamic> _criteria;
  @override
  Map<String, dynamic> get criteria {
    if (_criteria is EqualUnmodifiableMapView) return _criteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_criteria);
  }

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<String> _participants;
  @override
  @JsonKey()
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  @JsonKey()
  final SubChallengeStatus status;
  final Map<String, dynamic> _validationRules;
  @override
  @JsonKey()
  Map<String, dynamic> get validationRules {
    if (_validationRules is EqualUnmodifiableMapView) return _validationRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_validationRules);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SubChallenge(id: $id, parentChallengeId: $parentChallengeId, creatorId: $creatorId, title: $title, description: $description, criteria: $criteria, startDate: $startDate, endDate: $endDate, participants: $participants, status: $status, validationRules: $validationRules, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubChallengeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentChallengeId, parentChallengeId) ||
                other.parentChallengeId == parentChallengeId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._criteria, _criteria) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._validationRules, _validationRules) &&
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
      parentChallengeId,
      creatorId,
      title,
      description,
      const DeepCollectionEquality().hash(_criteria),
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_participants),
      status,
      const DeepCollectionEquality().hash(_validationRules),
      createdAt,
      updatedAt);

  /// Create a copy of SubChallenge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubChallengeImplCopyWith<_$SubChallengeImpl> get copyWith =>
      __$$SubChallengeImplCopyWithImpl<_$SubChallengeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubChallengeImplToJson(
      this,
    );
  }
}

abstract class _SubChallenge implements SubChallenge {
  const factory _SubChallenge(
      {required final String id,
      required final String parentChallengeId,
      required final String creatorId,
      required final String title,
      required final String description,
      required final Map<String, dynamic> criteria,
      required final DateTime startDate,
      required final DateTime endDate,
      final List<String> participants,
      final SubChallengeStatus status,
      final Map<String, dynamic> validationRules,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$SubChallengeImpl;

  factory _SubChallenge.fromJson(Map<String, dynamic> json) =
      _$SubChallengeImpl.fromJson;

  @override
  String get id;
  @override
  String get parentChallengeId;
  @override
  String get creatorId;
  @override
  String get title;
  @override
  String get description;
  @override
  Map<String, dynamic> get criteria;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<String> get participants;
  @override
  SubChallengeStatus get status;
  @override
  Map<String, dynamic> get validationRules;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SubChallenge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubChallengeImplCopyWith<_$SubChallengeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
