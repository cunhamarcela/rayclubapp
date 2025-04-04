// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'benefit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Benefit _$BenefitFromJson(Map<String, dynamic> json) {
  return _Benefit.fromJson(json);
}

/// @nodoc
mixin _$Benefit {
  /// Identificador único do benefício
  String get id => throw _privateConstructorUsedError;

  /// Título do benefício
  String get title => throw _privateConstructorUsedError;

  /// Descrição detalhada do benefício
  String get description => throw _privateConstructorUsedError;

  /// URL da imagem que representa o benefício
  String? get imageUrl => throw _privateConstructorUsedError;

  /// URL do QR Code do benefício (opcional)
  String? get qrCodeUrl => throw _privateConstructorUsedError;

  /// Data de expiração do benefício (opcional)
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Empresa ou marca parceira que fornece o benefício
  String get partner => throw _privateConstructorUsedError;

  /// Termos e condições para uso do benefício
  String? get terms => throw _privateConstructorUsedError;

  /// Tipo do benefício
  BenefitType get type => throw _privateConstructorUsedError;

  /// URL de ação associada ao benefício
  String? get actionUrl => throw _privateConstructorUsedError;

  /// Serializes this Benefit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Benefit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BenefitCopyWith<Benefit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BenefitCopyWith<$Res> {
  factory $BenefitCopyWith(Benefit value, $Res Function(Benefit) then) =
      _$BenefitCopyWithImpl<$Res, Benefit>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String? imageUrl,
      String? qrCodeUrl,
      DateTime? expiresAt,
      String partner,
      String? terms,
      BenefitType type,
      String? actionUrl});
}

/// @nodoc
class _$BenefitCopyWithImpl<$Res, $Val extends Benefit>
    implements $BenefitCopyWith<$Res> {
  _$BenefitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Benefit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? qrCodeUrl = freezed,
    Object? expiresAt = freezed,
    Object? partner = null,
    Object? terms = freezed,
    Object? type = null,
    Object? actionUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      partner: null == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BenefitType,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BenefitImplCopyWith<$Res> implements $BenefitCopyWith<$Res> {
  factory _$$BenefitImplCopyWith(
          _$BenefitImpl value, $Res Function(_$BenefitImpl) then) =
      __$$BenefitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String? imageUrl,
      String? qrCodeUrl,
      DateTime? expiresAt,
      String partner,
      String? terms,
      BenefitType type,
      String? actionUrl});
}

/// @nodoc
class __$$BenefitImplCopyWithImpl<$Res>
    extends _$BenefitCopyWithImpl<$Res, _$BenefitImpl>
    implements _$$BenefitImplCopyWith<$Res> {
  __$$BenefitImplCopyWithImpl(
      _$BenefitImpl _value, $Res Function(_$BenefitImpl) _then)
      : super(_value, _then);

  /// Create a copy of Benefit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? qrCodeUrl = freezed,
    Object? expiresAt = freezed,
    Object? partner = null,
    Object? terms = freezed,
    Object? type = null,
    Object? actionUrl = freezed,
  }) {
    return _then(_$BenefitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      partner: null == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BenefitType,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BenefitImpl implements _Benefit {
  const _$BenefitImpl(
      {required this.id,
      required this.title,
      required this.description,
      this.imageUrl,
      this.qrCodeUrl,
      this.expiresAt,
      required this.partner,
      this.terms,
      this.type = BenefitType.coupon,
      this.actionUrl});

  factory _$BenefitImpl.fromJson(Map<String, dynamic> json) =>
      _$$BenefitImplFromJson(json);

  /// Identificador único do benefício
  @override
  final String id;

  /// Título do benefício
  @override
  final String title;

  /// Descrição detalhada do benefício
  @override
  final String description;

  /// URL da imagem que representa o benefício
  @override
  final String? imageUrl;

  /// URL do QR Code do benefício (opcional)
  @override
  final String? qrCodeUrl;

  /// Data de expiração do benefício (opcional)
  @override
  final DateTime? expiresAt;

  /// Empresa ou marca parceira que fornece o benefício
  @override
  final String partner;

  /// Termos e condições para uso do benefício
  @override
  final String? terms;

  /// Tipo do benefício
  @override
  @JsonKey()
  final BenefitType type;

  /// URL de ação associada ao benefício
  @override
  final String? actionUrl;

  @override
  String toString() {
    return 'Benefit(id: $id, title: $title, description: $description, imageUrl: $imageUrl, qrCodeUrl: $qrCodeUrl, expiresAt: $expiresAt, partner: $partner, terms: $terms, type: $type, actionUrl: $actionUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenefitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.qrCodeUrl, qrCodeUrl) ||
                other.qrCodeUrl == qrCodeUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.terms, terms) || other.terms == terms) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, imageUrl,
      qrCodeUrl, expiresAt, partner, terms, type, actionUrl);

  /// Create a copy of Benefit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BenefitImplCopyWith<_$BenefitImpl> get copyWith =>
      __$$BenefitImplCopyWithImpl<_$BenefitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BenefitImplToJson(
      this,
    );
  }
}

abstract class _Benefit implements Benefit {
  const factory _Benefit(
      {required final String id,
      required final String title,
      required final String description,
      final String? imageUrl,
      final String? qrCodeUrl,
      final DateTime? expiresAt,
      required final String partner,
      final String? terms,
      final BenefitType type,
      final String? actionUrl}) = _$BenefitImpl;

  factory _Benefit.fromJson(Map<String, dynamic> json) = _$BenefitImpl.fromJson;

  /// Identificador único do benefício
  @override
  String get id;

  /// Título do benefício
  @override
  String get title;

  /// Descrição detalhada do benefício
  @override
  String get description;

  /// URL da imagem que representa o benefício
  @override
  String? get imageUrl;

  /// URL do QR Code do benefício (opcional)
  @override
  String? get qrCodeUrl;

  /// Data de expiração do benefício (opcional)
  @override
  DateTime? get expiresAt;

  /// Empresa ou marca parceira que fornece o benefício
  @override
  String get partner;

  /// Termos e condições para uso do benefício
  @override
  String? get terms;

  /// Tipo do benefício
  @override
  BenefitType get type;

  /// URL de ação associada ao benefício
  @override
  String? get actionUrl;

  /// Create a copy of Benefit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BenefitImplCopyWith<_$BenefitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
