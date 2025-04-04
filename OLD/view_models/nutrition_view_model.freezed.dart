// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NutritionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)
        success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionState value) $default, {
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NutritionState value)? $default, {
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NutritionState value)? $default, {
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionStateCopyWith<$Res> {
  factory $NutritionStateCopyWith(
          NutritionState value, $Res Function(NutritionState) then) =
      _$NutritionStateCopyWithImpl<$Res, NutritionState>;
}

/// @nodoc
class _$NutritionStateCopyWithImpl<$Res, $Val extends NutritionState>
    implements $NutritionStateCopyWith<$Res> {
  _$NutritionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NutritionStateImplCopyWith<$Res> {
  factory _$$NutritionStateImplCopyWith(_$NutritionStateImpl value,
          $Res Function(_$NutritionStateImpl) then) =
      __$$NutritionStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<NutritionItem> nutritionItems,
      List<NutritionItem> filteredItems,
      List<String> categories,
      String selectedCategory,
      NutritionItem? selectedItem,
      bool isLoading,
      String? errorMessage,
      String? successMessage});

  $NutritionItemCopyWith<$Res>? get selectedItem;
}

/// @nodoc
class __$$NutritionStateImplCopyWithImpl<$Res>
    extends _$NutritionStateCopyWithImpl<$Res, _$NutritionStateImpl>
    implements _$$NutritionStateImplCopyWith<$Res> {
  __$$NutritionStateImplCopyWithImpl(
      _$NutritionStateImpl _value, $Res Function(_$NutritionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionItems = null,
    Object? filteredItems = null,
    Object? categories = null,
    Object? selectedCategory = null,
    Object? selectedItem = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$NutritionStateImpl(
      nutritionItems: null == nutritionItems
          ? _value._nutritionItems
          : nutritionItems // ignore: cast_nullable_to_non_nullable
              as List<NutritionItem>,
      filteredItems: null == filteredItems
          ? _value._filteredItems
          : filteredItems // ignore: cast_nullable_to_non_nullable
              as List<NutritionItem>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
      selectedItem: freezed == selectedItem
          ? _value.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as NutritionItem?,
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

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionItemCopyWith<$Res>? get selectedItem {
    if (_value.selectedItem == null) {
      return null;
    }

    return $NutritionItemCopyWith<$Res>(_value.selectedItem!, (value) {
      return _then(_value.copyWith(selectedItem: value));
    });
  }
}

/// @nodoc

class _$NutritionStateImpl implements _NutritionState {
  const _$NutritionStateImpl(
      {final List<NutritionItem> nutritionItems = const [],
      final List<NutritionItem> filteredItems = const [],
      final List<String> categories = const [],
      this.selectedCategory = '',
      this.selectedItem,
      this.isLoading = false,
      this.errorMessage,
      this.successMessage})
      : _nutritionItems = nutritionItems,
        _filteredItems = filteredItems,
        _categories = categories;

  final List<NutritionItem> _nutritionItems;
  @override
  @JsonKey()
  List<NutritionItem> get nutritionItems {
    if (_nutritionItems is EqualUnmodifiableListView) return _nutritionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionItems);
  }

  final List<NutritionItem> _filteredItems;
  @override
  @JsonKey()
  List<NutritionItem> get filteredItems {
    if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredItems);
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
  final NutritionItem? selectedItem;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'NutritionState(nutritionItems: $nutritionItems, filteredItems: $filteredItems, categories: $categories, selectedCategory: $selectedCategory, selectedItem: $selectedItem, isLoading: $isLoading, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._nutritionItems, _nutritionItems) &&
            const DeepCollectionEquality()
                .equals(other._filteredItems, _filteredItems) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedItem, selectedItem) ||
                other.selectedItem == selectedItem) &&
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
      const DeepCollectionEquality().hash(_nutritionItems),
      const DeepCollectionEquality().hash(_filteredItems),
      const DeepCollectionEquality().hash(_categories),
      selectedCategory,
      selectedItem,
      isLoading,
      errorMessage,
      successMessage);

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionStateImplCopyWith<_$NutritionStateImpl> get copyWith =>
      __$$NutritionStateImplCopyWithImpl<_$NutritionStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return $default(nutritionItems, filteredItems, categories, selectedCategory,
        selectedItem, isLoading, errorMessage, successMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return $default?.call(
        nutritionItems,
        filteredItems,
        categories,
        selectedCategory,
        selectedItem,
        isLoading,
        errorMessage,
        successMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          nutritionItems,
          filteredItems,
          categories,
          selectedCategory,
          selectedItem,
          isLoading,
          errorMessage,
          successMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionState value) $default, {
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
    TResult? Function(_NutritionState value)? $default, {
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
    TResult Function(_NutritionState value)? $default, {
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

abstract class _NutritionState implements NutritionState {
  const factory _NutritionState(
      {final List<NutritionItem> nutritionItems,
      final List<NutritionItem> filteredItems,
      final List<String> categories,
      final String selectedCategory,
      final NutritionItem? selectedItem,
      final bool isLoading,
      final String? errorMessage,
      final String? successMessage}) = _$NutritionStateImpl;

  List<NutritionItem> get nutritionItems;
  List<NutritionItem> get filteredItems;
  List<String> get categories;
  String get selectedCategory;
  NutritionItem? get selectedItem;
  bool get isLoading;
  String? get errorMessage;
  String? get successMessage;

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionStateImplCopyWith<_$NutritionStateImpl> get copyWith =>
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
    extends _$NutritionStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'NutritionState.initial()';
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
    TResult Function(_NutritionState value) $default, {
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
    TResult? Function(_NutritionState value)? $default, {
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
    TResult Function(_NutritionState value)? $default, {
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

abstract class _Initial implements NutritionState {
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
    extends _$NutritionStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'NutritionState.loading()';
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
    TResult Function(_NutritionState value) $default, {
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
    TResult? Function(_NutritionState value)? $default, {
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
    TResult Function(_NutritionState value)? $default, {
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

abstract class _Loading implements NutritionState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<NutritionItem> nutritionItems,
      List<NutritionItem> filteredItems,
      List<String> categories,
      String selectedCategory,
      NutritionItem? selectedItem,
      String? message});

  $NutritionItemCopyWith<$Res>? get selectedItem;
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$NutritionStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nutritionItems = null,
    Object? filteredItems = null,
    Object? categories = null,
    Object? selectedCategory = null,
    Object? selectedItem = freezed,
    Object? message = freezed,
  }) {
    return _then(_$SuccessImpl(
      nutritionItems: null == nutritionItems
          ? _value._nutritionItems
          : nutritionItems // ignore: cast_nullable_to_non_nullable
              as List<NutritionItem>,
      filteredItems: null == filteredItems
          ? _value._filteredItems
          : filteredItems // ignore: cast_nullable_to_non_nullable
              as List<NutritionItem>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
      selectedItem: freezed == selectedItem
          ? _value.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as NutritionItem?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionItemCopyWith<$Res>? get selectedItem {
    if (_value.selectedItem == null) {
      return null;
    }

    return $NutritionItemCopyWith<$Res>(_value.selectedItem!, (value) {
      return _then(_value.copyWith(selectedItem: value));
    });
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(
      {required final List<NutritionItem> nutritionItems,
      required final List<NutritionItem> filteredItems,
      required final List<String> categories,
      this.selectedCategory = '',
      this.selectedItem,
      this.message})
      : _nutritionItems = nutritionItems,
        _filteredItems = filteredItems,
        _categories = categories;

  final List<NutritionItem> _nutritionItems;
  @override
  List<NutritionItem> get nutritionItems {
    if (_nutritionItems is EqualUnmodifiableListView) return _nutritionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutritionItems);
  }

  final List<NutritionItem> _filteredItems;
  @override
  List<NutritionItem> get filteredItems {
    if (_filteredItems is EqualUnmodifiableListView) return _filteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredItems);
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
  final NutritionItem? selectedItem;
  @override
  final String? message;

  @override
  String toString() {
    return 'NutritionState.success(nutritionItems: $nutritionItems, filteredItems: $filteredItems, categories: $categories, selectedCategory: $selectedCategory, selectedItem: $selectedItem, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            const DeepCollectionEquality()
                .equals(other._nutritionItems, _nutritionItems) &&
            const DeepCollectionEquality()
                .equals(other._filteredItems, _filteredItems) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedItem, selectedItem) ||
                other.selectedItem == selectedItem) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nutritionItems),
      const DeepCollectionEquality().hash(_filteredItems),
      const DeepCollectionEquality().hash(_categories),
      selectedCategory,
      selectedItem,
      message);

  /// Create a copy of NutritionState
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)
        success,
    required TResult Function(String message) error,
  }) {
    return success(nutritionItems, filteredItems, categories, selectedCategory,
        selectedItem, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)?
        success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(nutritionItems, filteredItems, categories,
        selectedCategory, selectedItem, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            String? message)?
        success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(nutritionItems, filteredItems, categories,
          selectedCategory, selectedItem, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NutritionState value) $default, {
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
    TResult? Function(_NutritionState value)? $default, {
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
    TResult Function(_NutritionState value)? $default, {
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

abstract class _Success implements NutritionState {
  const factory _Success(
      {required final List<NutritionItem> nutritionItems,
      required final List<NutritionItem> filteredItems,
      required final List<String> categories,
      final String selectedCategory,
      final NutritionItem? selectedItem,
      final String? message}) = _$SuccessImpl;

  List<NutritionItem> get nutritionItems;
  List<NutritionItem> get filteredItems;
  List<String> get categories;
  String get selectedCategory;
  NutritionItem? get selectedItem;
  String? get message;

  /// Create a copy of NutritionState
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
    extends _$NutritionStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionState
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
    return 'NutritionState.error(message: $message)';
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

  /// Create a copy of NutritionState
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)
        $default, {
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
            bool isLoading,
            String? errorMessage,
            String? successMessage)?
        $default, {
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<NutritionItem> nutritionItems,
            List<NutritionItem> filteredItems,
            List<String> categories,
            String selectedCategory,
            NutritionItem? selectedItem,
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
    TResult Function(_NutritionState value) $default, {
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
    TResult? Function(_NutritionState value)? $default, {
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
    TResult Function(_NutritionState value)? $default, {
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

abstract class _Error implements NutritionState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of NutritionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
