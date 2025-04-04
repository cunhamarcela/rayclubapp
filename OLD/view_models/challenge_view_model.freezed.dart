// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChallengeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)
        success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChallengeState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ChallengeState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ChallengeState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeStateCopyWith<$Res> {
  factory $ChallengeStateCopyWith(
          ChallengeState value, $Res Function(ChallengeState) then) =
      _$ChallengeStateCopyWithImpl<$Res, ChallengeState>;
}

/// @nodoc
class _$ChallengeStateCopyWithImpl<$Res, $Val extends ChallengeState>
    implements $ChallengeStateCopyWith<$Res> {
  _$ChallengeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ChallengeStateImplCopyWith<$Res> {
  factory _$$ChallengeStateImplCopyWith(_$ChallengeStateImpl value,
          $Res Function(_$ChallengeStateImpl) then) =
      __$$ChallengeStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Challenge> challenges,
      List<Challenge> filteredChallenges,
      Challenge? selectedChallenge,
      bool isLoading,
      String? errorMessage,
      String? successMessage});

  $ChallengeCopyWith<$Res>? get selectedChallenge;
}

/// @nodoc
class __$$ChallengeStateImplCopyWithImpl<$Res>
    extends _$ChallengeStateCopyWithImpl<$Res, _$ChallengeStateImpl>
    implements _$$ChallengeStateImplCopyWith<$Res> {
  __$$ChallengeStateImplCopyWithImpl(
      _$ChallengeStateImpl _value, $Res Function(_$ChallengeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? challenges = null,
    Object? filteredChallenges = null,
    Object? selectedChallenge = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$ChallengeStateImpl(
      challenges: null == challenges
          ? _value._challenges
          : challenges // ignore: cast_nullable_to_non_nullable
              as List<Challenge>,
      filteredChallenges: null == filteredChallenges
          ? _value._filteredChallenges
          : filteredChallenges // ignore: cast_nullable_to_non_nullable
              as List<Challenge>,
      selectedChallenge: freezed == selectedChallenge
          ? _value.selectedChallenge
          : selectedChallenge // ignore: cast_nullable_to_non_nullable
              as Challenge?,
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

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChallengeCopyWith<$Res>? get selectedChallenge {
    if (_value.selectedChallenge == null) {
      return null;
    }

    return $ChallengeCopyWith<$Res>(_value.selectedChallenge!, (value) {
      return _then(_value.copyWith(selectedChallenge: value));
    });
  }
}

/// @nodoc

class _$ChallengeStateImpl implements _ChallengeState {
  const _$ChallengeStateImpl(
      {final List<Challenge> challenges = const [],
      final List<Challenge> filteredChallenges = const [],
      this.selectedChallenge,
      this.isLoading = false,
      this.errorMessage,
      this.successMessage})
      : _challenges = challenges,
        _filteredChallenges = filteredChallenges;

  final List<Challenge> _challenges;
  @override
  @JsonKey()
  List<Challenge> get challenges {
    if (_challenges is EqualUnmodifiableListView) return _challenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_challenges);
  }

  final List<Challenge> _filteredChallenges;
  @override
  @JsonKey()
  List<Challenge> get filteredChallenges {
    if (_filteredChallenges is EqualUnmodifiableListView)
      return _filteredChallenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredChallenges);
  }

  @override
  final Challenge? selectedChallenge;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'ChallengeState(challenges: $challenges, filteredChallenges: $filteredChallenges, selectedChallenge: $selectedChallenge, isLoading: $isLoading, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._challenges, _challenges) &&
            const DeepCollectionEquality()
                .equals(other._filteredChallenges, _filteredChallenges) &&
            (identical(other.selectedChallenge, selectedChallenge) ||
                other.selectedChallenge == selectedChallenge) &&
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
      const DeepCollectionEquality().hash(_challenges),
      const DeepCollectionEquality().hash(_filteredChallenges),
      selectedChallenge,
      isLoading,
      errorMessage,
      successMessage);

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeStateImplCopyWith<_$ChallengeStateImpl> get copyWith =>
      __$$ChallengeStateImplCopyWithImpl<_$ChallengeStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return $default(challenges, filteredChallenges, selectedChallenge,
        isLoading, errorMessage, successMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return $default?.call(challenges, filteredChallenges, selectedChallenge,
        isLoading, errorMessage, successMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(challenges, filteredChallenges, selectedChallenge,
          isLoading, errorMessage, successMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChallengeState value) $default, {
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
    TResult? Function(_ChallengeState value)? $default, {
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
    TResult Function(_ChallengeState value)? $default, {
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

abstract class _ChallengeState implements ChallengeState {
  const factory _ChallengeState(
      {final List<Challenge> challenges,
      final List<Challenge> filteredChallenges,
      final Challenge? selectedChallenge,
      final bool isLoading,
      final String? errorMessage,
      final String? successMessage}) = _$ChallengeStateImpl;

  List<Challenge> get challenges;
  List<Challenge> get filteredChallenges;
  Challenge? get selectedChallenge;
  bool get isLoading;
  String? get errorMessage;
  String? get successMessage;

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChallengeStateImplCopyWith<_$ChallengeStateImpl> get copyWith =>
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
    extends _$ChallengeStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ChallengeState.initial()';
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
    TResult Function(_ChallengeState value) $default, {
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
    TResult? Function(_ChallengeState value)? $default, {
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
    TResult Function(_ChallengeState value)? $default, {
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

abstract class _Initial implements ChallengeState {
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
    extends _$ChallengeStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ChallengeState.loading()';
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
    TResult Function(_ChallengeState value) $default, {
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
    TResult? Function(_ChallengeState value)? $default, {
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
    TResult Function(_ChallengeState value)? $default, {
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

abstract class _Loading implements ChallengeState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Challenge> challenges,
      List<Challenge> filteredChallenges,
      Challenge? selectedChallenge,
      String? message});

  $ChallengeCopyWith<$Res>? get selectedChallenge;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$ChallengeStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? challenges = null,
    Object? filteredChallenges = null,
    Object? selectedChallenge = freezed,
    Object? message = freezed,
  }) {
    return _then(_$SuccessImpl(
      challenges: null == challenges
          ? _value._challenges
          : challenges // ignore: cast_nullable_to_non_nullable
              as List<Challenge>,
      filteredChallenges: null == filteredChallenges
          ? _value._filteredChallenges
          : filteredChallenges // ignore: cast_nullable_to_non_nullable
              as List<Challenge>,
      selectedChallenge: freezed == selectedChallenge
          ? _value.selectedChallenge
          : selectedChallenge // ignore: cast_nullable_to_non_nullable
              as Challenge?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChallengeCopyWith<$Res>? get selectedChallenge {
    if (_value.selectedChallenge == null) {
      return null;
    }

    return $ChallengeCopyWith<$Res>(_value.selectedChallenge!, (value) {
      return _then(_value.copyWith(selectedChallenge: value));
    });
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(
      {required final List<Challenge> challenges,
      final List<Challenge> filteredChallenges = const [],
      this.selectedChallenge,
      this.message})
      : _challenges = challenges,
        _filteredChallenges = filteredChallenges;

  final List<Challenge> _challenges;
  @override
  List<Challenge> get challenges {
    if (_challenges is EqualUnmodifiableListView) return _challenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_challenges);
  }

  final List<Challenge> _filteredChallenges;
  @override
  @JsonKey()
  List<Challenge> get filteredChallenges {
    if (_filteredChallenges is EqualUnmodifiableListView)
      return _filteredChallenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredChallenges);
  }

  @override
  final Challenge? selectedChallenge;
  @override
  final String? message;

  @override
  String toString() {
    return 'ChallengeState.success(challenges: $challenges, filteredChallenges: $filteredChallenges, selectedChallenge: $selectedChallenge, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            const DeepCollectionEquality()
                .equals(other._challenges, _challenges) &&
            const DeepCollectionEquality()
                .equals(other._filteredChallenges, _filteredChallenges) &&
            (identical(other.selectedChallenge, selectedChallenge) ||
                other.selectedChallenge == selectedChallenge) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_challenges),
      const DeepCollectionEquality().hash(_filteredChallenges),
      selectedChallenge,
      message);

  /// Create a copy of ChallengeState
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return success(challenges, filteredChallenges, selectedChallenge, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(
        challenges, filteredChallenges, selectedChallenge, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(
          challenges, filteredChallenges, selectedChallenge, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChallengeState value) $default, {
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
    TResult? Function(_ChallengeState value)? $default, {
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
    TResult Function(_ChallengeState value)? $default, {
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

abstract class _Success implements ChallengeState {
  const factory _Success(
      {required final List<Challenge> challenges,
      final List<Challenge> filteredChallenges,
      final Challenge? selectedChallenge,
      final String? message}) = _$SuccessImpl;

  List<Challenge> get challenges;
  List<Challenge> get filteredChallenges;
  Challenge? get selectedChallenge;
  String? get message;

  /// Create a copy of ChallengeState
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
    extends _$ChallengeStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengeState
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
    return 'ChallengeState.error(message: $message)';
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

  /// Create a copy of ChallengeState
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Challenge> challenges,
            List<Challenge> filteredChallenges,
            Challenge? selectedChallenge,
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
    TResult Function(_ChallengeState value) $default, {
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
    TResult? Function(_ChallengeState value)? $default, {
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
    TResult Function(_ChallengeState value)? $default, {
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

abstract class _Error implements ChallengeState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of ChallengeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
