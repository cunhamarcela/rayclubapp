// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'benefit_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BenefitState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)
        success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BenefitState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BenefitState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BenefitState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BenefitStateCopyWith<$Res> {
  factory $BenefitStateCopyWith(
          BenefitState value, $Res Function(BenefitState) then) =
      _$BenefitStateCopyWithImpl<$Res, BenefitState>;
}

/// @nodoc
class _$BenefitStateCopyWithImpl<$Res, $Val extends BenefitState>
    implements $BenefitStateCopyWith<$Res> {
  _$BenefitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BenefitStateImplCopyWith<$Res> {
  factory _$$BenefitStateImplCopyWith(
          _$BenefitStateImpl value, $Res Function(_$BenefitStateImpl) then) =
      __$$BenefitStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Benefit> benefits,
      List<Benefit> filteredBenefits,
      List<String> partners,
      String activeFilter,
      Benefit? selectedBenefit,
      bool isLoading,
      String? errorMessage,
      String? successMessage});

  $BenefitCopyWith<$Res>? get selectedBenefit;
}

/// @nodoc
class __$$BenefitStateImplCopyWithImpl<$Res>
    extends _$BenefitStateCopyWithImpl<$Res, _$BenefitStateImpl>
    implements _$$BenefitStateImplCopyWith<$Res> {
  __$$BenefitStateImplCopyWithImpl(
      _$BenefitStateImpl _value, $Res Function(_$BenefitStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? benefits = null,
    Object? filteredBenefits = null,
    Object? partners = null,
    Object? activeFilter = null,
    Object? selectedBenefit = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$BenefitStateImpl(
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<Benefit>,
      filteredBenefits: null == filteredBenefits
          ? _value._filteredBenefits
          : filteredBenefits // ignore: cast_nullable_to_non_nullable
              as List<Benefit>,
      partners: null == partners
          ? _value._partners
          : partners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeFilter: null == activeFilter
          ? _value.activeFilter
          : activeFilter // ignore: cast_nullable_to_non_nullable
              as String,
      selectedBenefit: freezed == selectedBenefit
          ? _value.selectedBenefit
          : selectedBenefit // ignore: cast_nullable_to_non_nullable
              as Benefit?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BenefitCopyWith<$Res>? get selectedBenefit {
    if (_value.selectedBenefit == null) {
      return null;
    }

    return $BenefitCopyWith<$Res>(_value.selectedBenefit!, (value) {
      return _then(_value.copyWith(selectedBenefit: value));
    });
  }
}

/// @nodoc

class _$BenefitStateImpl implements _BenefitState {
  const _$BenefitStateImpl(
      {final List<Benefit> benefits = const [],
      final List<Benefit> filteredBenefits = const [],
      final List<String> partners = const [],
      this.activeFilter = 'all',
      this.selectedBenefit,
      this.isLoading = false,
      this.errorMessage,
      this.successMessage})
      : _benefits = benefits,
        _filteredBenefits = filteredBenefits,
        _partners = partners;

  final List<Benefit> _benefits;
  @override
  @JsonKey()
  List<Benefit> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  final List<Benefit> _filteredBenefits;
  @override
  @JsonKey()
  List<Benefit> get filteredBenefits {
    if (_filteredBenefits is EqualUnmodifiableListView)
      return _filteredBenefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredBenefits);
  }

  final List<String> _partners;
  @override
  @JsonKey()
  List<String> get partners {
    if (_partners is EqualUnmodifiableListView) return _partners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partners);
  }

  @override
  @JsonKey()
  final String activeFilter;
  @override
  final Benefit? selectedBenefit;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'BenefitState(benefits: $benefits, filteredBenefits: $filteredBenefits, partners: $partners, activeFilter: $activeFilter, selectedBenefit: $selectedBenefit, isLoading: $isLoading, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BenefitStateImpl &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            const DeepCollectionEquality()
                .equals(other._filteredBenefits, _filteredBenefits) &&
            const DeepCollectionEquality().equals(other._partners, _partners) &&
            (identical(other.activeFilter, activeFilter) ||
                other.activeFilter == activeFilter) &&
            (identical(other.selectedBenefit, selectedBenefit) ||
                other.selectedBenefit == selectedBenefit) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_benefits),
      const DeepCollectionEquality().hash(_filteredBenefits),
      const DeepCollectionEquality().hash(_partners),
      activeFilter,
      selectedBenefit,
      isLoading,
      errorMessage,
      successMessage);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BenefitStateImplCopyWith<_$BenefitStateImpl> get copyWith =>
      __$$BenefitStateImplCopyWithImpl<_$BenefitStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return $default(benefits, filteredBenefits, partners, activeFilter,
        selectedBenefit, isLoading, errorMessage, successMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return $default?.call(benefits, filteredBenefits, partners, activeFilter,
        selectedBenefit, isLoading, errorMessage, successMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(benefits, filteredBenefits, partners, activeFilter,
          selectedBenefit, isLoading, errorMessage, successMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BenefitState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BenefitState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BenefitState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _BenefitState implements BenefitState {
  const factory _BenefitState(
      {final List<Benefit> benefits,
      final List<Benefit> filteredBenefits,
      final List<String> partners,
      final String activeFilter,
      final Benefit? selectedBenefit,
      final bool isLoading,
      final String? errorMessage,
      final String? successMessage}) = _$BenefitStateImpl;

  List<Benefit> get benefits;
  List<Benefit> get filteredBenefits;
  List<String> get partners;
  String get activeFilter;
  Benefit? get selectedBenefit;
  bool get isLoading;
  String? get errorMessage;
  String? get successMessage;

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BenefitStateImplCopyWith<_$BenefitStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$BenefitStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'BenefitState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BenefitState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BenefitState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BenefitState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements BenefitState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$BenefitStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'BenefitState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BenefitState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BenefitState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BenefitState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements BenefitState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Benefit> benefits,
      List<Benefit> filteredBenefits,
      List<String> partners,
      String activeFilter,
      Benefit? selectedBenefit,
      String? message});

  $BenefitCopyWith<$Res>? get selectedBenefit;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$BenefitStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? benefits = null,
    Object? filteredBenefits = null,
    Object? partners = null,
    Object? activeFilter = null,
    Object? selectedBenefit = freezed,
    Object? message = freezed,
  }) {
    return _then(_$SuccessImpl(
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as List<Benefit>,
      filteredBenefits: null == filteredBenefits
          ? _value._filteredBenefits
          : filteredBenefits // ignore: cast_nullable_to_non_nullable
              as List<Benefit>,
      partners: null == partners
          ? _value._partners
          : partners // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeFilter: null == activeFilter
          ? _value.activeFilter
          : activeFilter // ignore: cast_nullable_to_non_nullable
              as String,
      selectedBenefit: freezed == selectedBenefit
          ? _value.selectedBenefit
          : selectedBenefit // ignore: cast_nullable_to_non_nullable
              as Benefit?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BenefitCopyWith<$Res>? get selectedBenefit {
    if (_value.selectedBenefit == null) {
      return null;
    }

    return $BenefitCopyWith<$Res>(_value.selectedBenefit!, (value) {
      return _then(_value.copyWith(selectedBenefit: value));
    });
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(
      {required final List<Benefit> benefits,
      final List<Benefit> filteredBenefits = const [],
      final List<String> partners = const [],
      this.activeFilter = 'all',
      this.selectedBenefit,
      this.message})
      : _benefits = benefits,
        _filteredBenefits = filteredBenefits,
        _partners = partners;

  final List<Benefit> _benefits;
  @override
  List<Benefit> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  final List<Benefit> _filteredBenefits;
  @override
  @JsonKey()
  List<Benefit> get filteredBenefits {
    if (_filteredBenefits is EqualUnmodifiableListView)
      return _filteredBenefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredBenefits);
  }

  final List<String> _partners;
  @override
  @JsonKey()
  List<String> get partners {
    if (_partners is EqualUnmodifiableListView) return _partners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partners);
  }

  @override
  @JsonKey()
  final String activeFilter;
  @override
  final Benefit? selectedBenefit;
  @override
  final String? message;

  @override
  String toString() {
    return 'BenefitState.success(benefits: $benefits, filteredBenefits: $filteredBenefits, partners: $partners, activeFilter: $activeFilter, selectedBenefit: $selectedBenefit, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            const DeepCollectionEquality()
                .equals(other._filteredBenefits, _filteredBenefits) &&
            const DeepCollectionEquality().equals(other._partners, _partners) &&
            (identical(other.activeFilter, activeFilter) ||
                other.activeFilter == activeFilter) &&
            (identical(other.selectedBenefit, selectedBenefit) ||
                other.selectedBenefit == selectedBenefit) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_benefits),
      const DeepCollectionEquality().hash(_filteredBenefits),
      const DeepCollectionEquality().hash(_partners),
      activeFilter,
      selectedBenefit,
      message);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return success(benefits, filteredBenefits, partners, activeFilter,
        selectedBenefit, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(benefits, filteredBenefits, partners, activeFilter,
        selectedBenefit, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(benefits, filteredBenefits, partners, activeFilter,
          selectedBenefit, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BenefitState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BenefitState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BenefitState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements BenefitState {
  const factory _Success(
      {required final List<Benefit> benefits,
      final List<Benefit> filteredBenefits,
      final List<String> partners,
      final String activeFilter,
      final Benefit? selectedBenefit,
      final String? message}) = _$SuccessImpl;

  List<Benefit> get benefits;
  List<Benefit> get filteredBenefits;
  List<String> get partners;
  String get activeFilter;
  Benefit? get selectedBenefit;
  String? get message;

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$BenefitStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'BenefitState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Benefit> benefits,
            List<Benefit> filteredBenefits,
            List<String> partners,
            String activeFilter,
            Benefit? selectedBenefit,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BenefitState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BenefitState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BenefitState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements BenefitState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of BenefitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
