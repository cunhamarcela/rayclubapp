// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)
        success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkoutState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WorkoutState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WorkoutState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutStateCopyWith<$Res> {
  factory $WorkoutStateCopyWith(
          WorkoutState value, $Res Function(WorkoutState) then) =
      _$WorkoutStateCopyWithImpl<$Res, WorkoutState>;
}

/// @nodoc
class _$WorkoutStateCopyWithImpl<$Res, $Val extends WorkoutState>
    implements $WorkoutStateCopyWith<$Res> {
  _$WorkoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$WorkoutStateImplCopyWith<$Res> {
  factory _$$WorkoutStateImplCopyWith(
          _$WorkoutStateImpl value, $Res Function(_$WorkoutStateImpl) then) =
      __$$WorkoutStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Workout> workouts,
      List<Workout> filteredWorkouts,
      List<String> categories,
      String selectedCategory,
      int selectedDurationFilter,
      bool isLoading,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class __$$WorkoutStateImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$WorkoutStateImpl>
    implements _$$WorkoutStateImplCopyWith<$Res> {
  __$$WorkoutStateImplCopyWithImpl(
      _$WorkoutStateImpl _value, $Res Function(_$WorkoutStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workouts = null,
    Object? filteredWorkouts = null,
    Object? categories = null,
    Object? selectedCategory = null,
    Object? selectedDurationFilter = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$WorkoutStateImpl(
      workouts: null == workouts
          ? _value._workouts
          : workouts // ignore: cast_nullable_to_non_nullable
              as List<Workout>,
      filteredWorkouts: null == filteredWorkouts
          ? _value._filteredWorkouts
          : filteredWorkouts // ignore: cast_nullable_to_non_nullable
              as List<Workout>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDurationFilter: null == selectedDurationFilter
          ? _value.selectedDurationFilter
          : selectedDurationFilter // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc

class _$WorkoutStateImpl implements _WorkoutState {
  const _$WorkoutStateImpl(
      {final List<Workout> workouts = const [],
      final List<Workout> filteredWorkouts = const [],
      final List<String> categories = const [],
      this.selectedCategory = '',
      this.selectedDurationFilter = 0,
      this.isLoading = false,
      this.errorMessage,
      this.successMessage})
      : _workouts = workouts,
        _filteredWorkouts = filteredWorkouts,
        _categories = categories;

  final List<Workout> _workouts;
  @override
  @JsonKey()
  List<Workout> get workouts {
    if (_workouts is EqualUnmodifiableListView) return _workouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workouts);
  }

  final List<Workout> _filteredWorkouts;
  @override
  @JsonKey()
  List<Workout> get filteredWorkouts {
    if (_filteredWorkouts is EqualUnmodifiableListView)
      return _filteredWorkouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredWorkouts);
  }

  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final String selectedCategory;
  @override
  @JsonKey()
  final int selectedDurationFilter;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'WorkoutState(workouts: $workouts, filteredWorkouts: $filteredWorkouts, categories: $categories, selectedCategory: $selectedCategory, selectedDurationFilter: $selectedDurationFilter, isLoading: $isLoading, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutStateImpl &&
            const DeepCollectionEquality().equals(other._workouts, _workouts) &&
            const DeepCollectionEquality()
                .equals(other._filteredWorkouts, _filteredWorkouts) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedDurationFilter, selectedDurationFilter) ||
                other.selectedDurationFilter == selectedDurationFilter) &&
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
      const DeepCollectionEquality().hash(_workouts),
      const DeepCollectionEquality().hash(_filteredWorkouts),
      const DeepCollectionEquality().hash(_categories),
      selectedCategory,
      selectedDurationFilter,
      isLoading,
      errorMessage,
      successMessage);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutStateImplCopyWith<_$WorkoutStateImpl> get copyWith =>
      __$$WorkoutStateImplCopyWithImpl<_$WorkoutStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return $default(workouts, filteredWorkouts, categories, selectedCategory,
        selectedDurationFilter, isLoading, errorMessage, successMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return $default?.call(
        workouts,
        filteredWorkouts,
        categories,
        selectedCategory,
        selectedDurationFilter,
        isLoading,
        errorMessage,
        successMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(workouts, filteredWorkouts, categories, selectedCategory,
          selectedDurationFilter, isLoading, errorMessage, successMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkoutState value) $default, {
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
    TResult? Function(_WorkoutState value)? $default, {
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
    TResult Function(_WorkoutState value)? $default, {
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

abstract class _WorkoutState implements WorkoutState {
  const factory _WorkoutState(
      {final List<Workout> workouts,
      final List<Workout> filteredWorkouts,
      final List<String> categories,
      final String selectedCategory,
      final int selectedDurationFilter,
      final bool isLoading,
      final String? errorMessage,
      final String? successMessage}) = _$WorkoutStateImpl;

  List<Workout> get workouts;
  List<Workout> get filteredWorkouts;
  List<String> get categories;
  String get selectedCategory;
  int get selectedDurationFilter;
  bool get isLoading;
  String? get errorMessage;
  String? get successMessage;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutStateImplCopyWith<_$WorkoutStateImpl> get copyWith =>
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
    extends _$WorkoutStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'WorkoutState.initial()';
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
    TResult Function(_WorkoutState value) $default, {
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
    TResult? Function(_WorkoutState value)? $default, {
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
    TResult Function(_WorkoutState value)? $default, {
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

abstract class _Initial implements WorkoutState {
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
    extends _$WorkoutStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'WorkoutState.loading()';
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
    TResult Function(_WorkoutState value) $default, {
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
    TResult? Function(_WorkoutState value)? $default, {
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
    TResult Function(_WorkoutState value)? $default, {
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

abstract class _Loading implements WorkoutState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Workout> workouts,
      List<Workout> filteredWorkouts,
      List<String> categories,
      String selectedCategory,
      int selectedDurationFilter,
      String? message});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workouts = null,
    Object? filteredWorkouts = null,
    Object? categories = null,
    Object? selectedCategory = null,
    Object? selectedDurationFilter = null,
    Object? message = freezed,
  }) {
    return _then(_$SuccessImpl(
      workouts: null == workouts
          ? _value._workouts
          : workouts // ignore: cast_nullable_to_non_nullable
              as List<Workout>,
      filteredWorkouts: null == filteredWorkouts
          ? _value._filteredWorkouts
          : filteredWorkouts // ignore: cast_nullable_to_non_nullable
              as List<Workout>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDurationFilter: null == selectedDurationFilter
          ? _value.selectedDurationFilter
          : selectedDurationFilter // ignore: cast_nullable_to_non_nullable
              as int,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(
      {required final List<Workout> workouts,
      required final List<Workout> filteredWorkouts,
      required final List<String> categories,
      this.selectedCategory = '',
      this.selectedDurationFilter = 0,
      this.message})
      : _workouts = workouts,
        _filteredWorkouts = filteredWorkouts,
        _categories = categories;

  final List<Workout> _workouts;
  @override
  List<Workout> get workouts {
    if (_workouts is EqualUnmodifiableListView) return _workouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workouts);
  }

  final List<Workout> _filteredWorkouts;
  @override
  List<Workout> get filteredWorkouts {
    if (_filteredWorkouts is EqualUnmodifiableListView)
      return _filteredWorkouts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredWorkouts);
  }

  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final String selectedCategory;
  @override
  @JsonKey()
  final int selectedDurationFilter;
  @override
  final String? message;

  @override
  String toString() {
    return 'WorkoutState.success(workouts: $workouts, filteredWorkouts: $filteredWorkouts, categories: $categories, selectedCategory: $selectedCategory, selectedDurationFilter: $selectedDurationFilter, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            const DeepCollectionEquality().equals(other._workouts, _workouts) &&
            const DeepCollectionEquality()
                .equals(other._filteredWorkouts, _filteredWorkouts) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedDurationFilter, selectedDurationFilter) ||
                other.selectedDurationFilter == selectedDurationFilter) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_workouts),
      const DeepCollectionEquality().hash(_filteredWorkouts),
      const DeepCollectionEquality().hash(_categories),
      selectedCategory,
      selectedDurationFilter,
      message);

  /// Create a copy of WorkoutState
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return success(workouts, filteredWorkouts, categories, selectedCategory,
        selectedDurationFilter, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(workouts, filteredWorkouts, categories,
        selectedCategory, selectedDurationFilter, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(workouts, filteredWorkouts, categories, selectedCategory,
          selectedDurationFilter, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WorkoutState value) $default, {
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
    TResult? Function(_WorkoutState value)? $default, {
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
    TResult Function(_WorkoutState value)? $default, {
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

abstract class _Success implements WorkoutState {
  const factory _Success(
      {required final List<Workout> workouts,
      required final List<Workout> filteredWorkouts,
      required final List<String> categories,
      final String selectedCategory,
      final int selectedDurationFilter,
      final String? message}) = _$SuccessImpl;

  List<Workout> get workouts;
  List<Workout> get filteredWorkouts;
  List<String> get categories;
  String get selectedCategory;
  int get selectedDurationFilter;
  String? get message;

  /// Create a copy of WorkoutState
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
    extends _$WorkoutStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
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
    return 'WorkoutState.error(message: $message)';
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

  /// Create a copy of WorkoutState
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Workout> workouts,
            List<Workout> filteredWorkouts,
            List<String> categories,
            String selectedCategory,
            int selectedDurationFilter,
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
    TResult Function(_WorkoutState value) $default, {
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
    TResult? Function(_WorkoutState value)? $default, {
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
    TResult Function(_WorkoutState value)? $default, {
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

abstract class _Error implements WorkoutState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
