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
  String get imageUrl => throw _privateConstructorUsedError;

  /// Quantidade de pontos necessários para resgatar o benefício
  int get pointsRequired => throw _privateConstructorUsedError;

  /// Data de expiração do benefício (opcional)
  DateTime? get expirationDate => throw _privateConstructorUsedError;

  /// Código promocional do benefício (opcional)
  String? get promoCode => throw _privateConstructorUsedError;

  /// Empresa ou marca parceira que fornece o benefício
  String? get partner => throw _privateConstructorUsedError;

  /// Categoria do benefício para agrupamento
  String get category => throw _privateConstructorUsedError;

  /// Termos e condições para uso do benefício
  String? get termsAndConditions => throw _privateConstructorUsedError;

  /// Indica se o benefício foi destacado para promoção especial
  bool get isFeatured => throw _privateConstructorUsedError;

  /// Quantidade disponível (null para ilimitado)
  int? get availableQuantity => throw _privateConstructorUsedError;

  /// Link externo para redireção ao resgatar o benefício
  String? get externalUrl => throw _privateConstructorUsedError;

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
      String imageUrl,
      int pointsRequired,
      DateTime? expirationDate,
      String? promoCode,
      String? partner,
      String category,
      String? termsAndConditions,
      bool isFeatured,
      int? availableQuantity,
      String? externalUrl});
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
    Object? imageUrl = null,
    Object? pointsRequired = null,
    Object? expirationDate = freezed,
    Object? promoCode = freezed,
    Object? partner = freezed,
    Object? category = null,
    Object? termsAndConditions = freezed,
    Object? isFeatured = null,
    Object? availableQuantity = freezed,
    Object? externalUrl = freezed,
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
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      pointsRequired: null == pointsRequired
          ? _value.pointsRequired
          : pointsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      availableQuantity: freezed == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
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
      String imageUrl,
      int pointsRequired,
      DateTime? expirationDate,
      String? promoCode,
      String? partner,
      String category,
      String? termsAndConditions,
      bool isFeatured,
      int? availableQuantity,
      String? externalUrl});
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
    Object? imageUrl = null,
    Object? pointsRequired = null,
    Object? expirationDate = freezed,
    Object? promoCode = freezed,
    Object? partner = freezed,
    Object? category = null,
    Object? termsAndConditions = freezed,
    Object? isFeatured = null,
    Object? availableQuantity = freezed,
    Object? externalUrl = freezed,
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
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      pointsRequired: null == pointsRequired
          ? _value.pointsRequired
          : pointsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      availableQuantity: freezed == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
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
      required this.imageUrl,
      required this.pointsRequired,
      this.expirationDate,
      this.promoCode,
      this.partner,
      this.category = "Outros",
      this.termsAndConditions,
      this.isFeatured = false,
      this.availableQuantity,
      this.externalUrl});

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
  final String imageUrl;

  /// Quantidade de pontos necessários para resgatar o benefício
  @override
  final int pointsRequired;

  /// Data de expiração do benefício (opcional)
  @override
  final DateTime? expirationDate;

  /// Código promocional do benefício (opcional)
  @override
  final String? promoCode;

  /// Empresa ou marca parceira que fornece o benefício
  @override
  final String? partner;

  /// Categoria do benefício para agrupamento
  @override
  @JsonKey()
  final String category;

  /// Termos e condições para uso do benefício
  @override
  final String? termsAndConditions;

  /// Indica se o benefício foi destacado para promoção especial
  @override
  @JsonKey()
  final bool isFeatured;

  /// Quantidade disponível (null para ilimitado)
  @override
  final int? availableQuantity;

  /// Link externo para redireção ao resgatar o benefício
  @override
  final String? externalUrl;

  @override
  String toString() {
    return 'Benefit(id: $id, title: $title, description: $description, imageUrl: $imageUrl, pointsRequired: $pointsRequired, expirationDate: $expirationDate, promoCode: $promoCode, partner: $partner, category: $category, termsAndConditions: $termsAndConditions, isFeatured: $isFeatured, availableQuantity: $availableQuantity, externalUrl: $externalUrl)';
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
            (identical(other.pointsRequired, pointsRequired) ||
                other.pointsRequired == pointsRequired) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      imageUrl,
      pointsRequired,
      expirationDate,
      promoCode,
      partner,
      category,
      termsAndConditions,
      isFeatured,
      availableQuantity,
      externalUrl);

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
      required final String imageUrl,
      required final int pointsRequired,
      final DateTime? expirationDate,
      final String? promoCode,
      final String? partner,
      final String category,
      final String? termsAndConditions,
      final bool isFeatured,
      final int? availableQuantity,
      final String? externalUrl}) = _$BenefitImpl;

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
  String get imageUrl;

  /// Quantidade de pontos necessários para resgatar o benefício
  @override
  int get pointsRequired;

  /// Data de expiração do benefício (opcional)
  @override
  DateTime? get expirationDate;

  /// Código promocional do benefício (opcional)
  @override
  String? get promoCode;

  /// Empresa ou marca parceira que fornece o benefício
  @override
  String? get partner;

  /// Categoria do benefício para agrupamento
  @override
  String get category;

  /// Termos e condições para uso do benefício
  @override
  String? get termsAndConditions;

  /// Indica se o benefício foi destacado para promoção especial
  @override
  bool get isFeatured;

  /// Quantidade disponível (null para ilimitado)
  @override
  int? get availableQuantity;

  /// Link externo para redireção ao resgatar o benefício
  @override
  String? get externalUrl;

  /// Create a copy of Benefit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BenefitImplCopyWith<_$BenefitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
