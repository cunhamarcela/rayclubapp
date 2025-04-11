// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HelpState {
  /// Lista de perguntas frequentes
  List<Faq> get faqs => throw _privateConstructorUsedError;

  /// Índice da FAQ expandida, -1 se nenhuma estiver expandida
  int get expandedFaqIndex => throw _privateConstructorUsedError;

  /// Indica se está carregando dados
  bool get isLoading => throw _privateConstructorUsedError;

  /// Mensagem de erro, se houver
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of HelpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HelpStateCopyWith<HelpState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpStateCopyWith<$Res> {
  factory $HelpStateCopyWith(HelpState value, $Res Function(HelpState) then) =
      _$HelpStateCopyWithImpl<$Res, HelpState>;
  @useResult
  $Res call(
      {List<Faq> faqs,
      int expandedFaqIndex,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$HelpStateCopyWithImpl<$Res, $Val extends HelpState>
    implements $HelpStateCopyWith<$Res> {
  _$HelpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HelpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faqs = null,
    Object? expandedFaqIndex = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      faqs: null == faqs
          ? _value.faqs
          : faqs // ignore: cast_nullable_to_non_nullable
              as List<Faq>,
      expandedFaqIndex: null == expandedFaqIndex
          ? _value.expandedFaqIndex
          : expandedFaqIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpStateImplCopyWith<$Res>
    implements $HelpStateCopyWith<$Res> {
  factory _$$HelpStateImplCopyWith(
          _$HelpStateImpl value, $Res Function(_$HelpStateImpl) then) =
      __$$HelpStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Faq> faqs,
      int expandedFaqIndex,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$HelpStateImplCopyWithImpl<$Res>
    extends _$HelpStateCopyWithImpl<$Res, _$HelpStateImpl>
    implements _$$HelpStateImplCopyWith<$Res> {
  __$$HelpStateImplCopyWithImpl(
      _$HelpStateImpl _value, $Res Function(_$HelpStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HelpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faqs = null,
    Object? expandedFaqIndex = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HelpStateImpl(
      faqs: null == faqs
          ? _value._faqs
          : faqs // ignore: cast_nullable_to_non_nullable
              as List<Faq>,
      expandedFaqIndex: null == expandedFaqIndex
          ? _value.expandedFaqIndex
          : expandedFaqIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HelpStateImpl implements _HelpState {
  const _$HelpStateImpl(
      {final List<Faq> faqs = const [],
      this.expandedFaqIndex = -1,
      this.isLoading = false,
      this.errorMessage})
      : _faqs = faqs;

  /// Lista de perguntas frequentes
  final List<Faq> _faqs;

  /// Lista de perguntas frequentes
  @override
  @JsonKey()
  List<Faq> get faqs {
    if (_faqs is EqualUnmodifiableListView) return _faqs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_faqs);
  }

  /// Índice da FAQ expandida, -1 se nenhuma estiver expandida
  @override
  @JsonKey()
  final int expandedFaqIndex;

  /// Indica se está carregando dados
  @override
  @JsonKey()
  final bool isLoading;

  /// Mensagem de erro, se houver
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HelpState(faqs: $faqs, expandedFaqIndex: $expandedFaqIndex, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpStateImpl &&
            const DeepCollectionEquality().equals(other._faqs, _faqs) &&
            (identical(other.expandedFaqIndex, expandedFaqIndex) ||
                other.expandedFaqIndex == expandedFaqIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_faqs),
      expandedFaqIndex,
      isLoading,
      errorMessage);

  /// Create a copy of HelpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpStateImplCopyWith<_$HelpStateImpl> get copyWith =>
      __$$HelpStateImplCopyWithImpl<_$HelpStateImpl>(this, _$identity);
}

abstract class _HelpState implements HelpState {
  const factory _HelpState(
      {final List<Faq> faqs,
      final int expandedFaqIndex,
      final bool isLoading,
      final String? errorMessage}) = _$HelpStateImpl;

  /// Lista de perguntas frequentes
  @override
  List<Faq> get faqs;

  /// Índice da FAQ expandida, -1 se nenhuma estiver expandida
  @override
  int get expandedFaqIndex;

  /// Indica se está carregando dados
  @override
  bool get isLoading;

  /// Mensagem de erro, se houver
  @override
  String? get errorMessage;

  /// Create a copy of HelpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HelpStateImplCopyWith<_$HelpStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
