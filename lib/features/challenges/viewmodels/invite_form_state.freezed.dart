// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InviteFormState _$InviteFormStateFromJson(Map<String, dynamic> json) {
  return _InviteFormState.fromJson(json);
}

/// @nodoc
mixin _$InviteFormState {
  /// Lista de todos os perfis disponíveis
  List<Profile> get allProfiles => throw _privateConstructorUsedError;

  /// Lista de perfis paginados e filtrados para exibição
  List<Profile> get paginatedProfiles => throw _privateConstructorUsedError;

  /// Lista de usuários selecionados para convite
  List<Profile> get selectedUsers => throw _privateConstructorUsedError;

  /// Termo de busca atual
  String get searchQuery => throw _privateConstructorUsedError;

  /// Número da página atual (para paginação)
  int get currentPage => throw _privateConstructorUsedError;

  /// Indica se há mais dados para carregar
  bool get hasMoreData => throw _privateConstructorUsedError;

  /// Indica se está carregando mais dados
  bool get isLoadingMore => throw _privateConstructorUsedError;

  /// Mensagem de erro, se houver
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Mensagem de sucesso, se houver
  String? get successMessage => throw _privateConstructorUsedError;

  /// Serializes this InviteFormState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteFormStateCopyWith<InviteFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteFormStateCopyWith<$Res> {
  factory $InviteFormStateCopyWith(
          InviteFormState value, $Res Function(InviteFormState) then) =
      _$InviteFormStateCopyWithImpl<$Res, InviteFormState>;
  @useResult
  $Res call(
      {List<Profile> allProfiles,
      List<Profile> paginatedProfiles,
      List<Profile> selectedUsers,
      String searchQuery,
      int currentPage,
      bool hasMoreData,
      bool isLoadingMore,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class _$InviteFormStateCopyWithImpl<$Res, $Val extends InviteFormState>
    implements $InviteFormStateCopyWith<$Res> {
  _$InviteFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allProfiles = null,
    Object? paginatedProfiles = null,
    Object? selectedUsers = null,
    Object? searchQuery = null,
    Object? currentPage = null,
    Object? hasMoreData = null,
    Object? isLoadingMore = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_value.copyWith(
      allProfiles: null == allProfiles
          ? _value.allProfiles
          : allProfiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      paginatedProfiles: null == paginatedProfiles
          ? _value.paginatedProfiles
          : paginatedProfiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      selectedUsers: null == selectedUsers
          ? _value.selectedUsers
          : selectedUsers // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreData: null == hasMoreData
          ? _value.hasMoreData
          : hasMoreData // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteFormStateImplCopyWith<$Res>
    implements $InviteFormStateCopyWith<$Res> {
  factory _$$InviteFormStateImplCopyWith(_$InviteFormStateImpl value,
          $Res Function(_$InviteFormStateImpl) then) =
      __$$InviteFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Profile> allProfiles,
      List<Profile> paginatedProfiles,
      List<Profile> selectedUsers,
      String searchQuery,
      int currentPage,
      bool hasMoreData,
      bool isLoadingMore,
      String? errorMessage,
      String? successMessage});
}

/// @nodoc
class __$$InviteFormStateImplCopyWithImpl<$Res>
    extends _$InviteFormStateCopyWithImpl<$Res, _$InviteFormStateImpl>
    implements _$$InviteFormStateImplCopyWith<$Res> {
  __$$InviteFormStateImplCopyWithImpl(
      _$InviteFormStateImpl _value, $Res Function(_$InviteFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allProfiles = null,
    Object? paginatedProfiles = null,
    Object? selectedUsers = null,
    Object? searchQuery = null,
    Object? currentPage = null,
    Object? hasMoreData = null,
    Object? isLoadingMore = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$InviteFormStateImpl(
      allProfiles: null == allProfiles
          ? _value._allProfiles
          : allProfiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      paginatedProfiles: null == paginatedProfiles
          ? _value._paginatedProfiles
          : paginatedProfiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      selectedUsers: null == selectedUsers
          ? _value._selectedUsers
          : selectedUsers // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreData: null == hasMoreData
          ? _value.hasMoreData
          : hasMoreData // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$InviteFormStateImpl implements _InviteFormState {
  const _$InviteFormStateImpl(
      {final List<Profile> allProfiles = const [],
      final List<Profile> paginatedProfiles = const [],
      final List<Profile> selectedUsers = const [],
      this.searchQuery = '',
      this.currentPage = 0,
      this.hasMoreData = true,
      this.isLoadingMore = false,
      this.errorMessage,
      this.successMessage})
      : _allProfiles = allProfiles,
        _paginatedProfiles = paginatedProfiles,
        _selectedUsers = selectedUsers;

  factory _$InviteFormStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteFormStateImplFromJson(json);

  /// Lista de todos os perfis disponíveis
  final List<Profile> _allProfiles;

  /// Lista de todos os perfis disponíveis
  @override
  @JsonKey()
  List<Profile> get allProfiles {
    if (_allProfiles is EqualUnmodifiableListView) return _allProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allProfiles);
  }

  /// Lista de perfis paginados e filtrados para exibição
  final List<Profile> _paginatedProfiles;

  /// Lista de perfis paginados e filtrados para exibição
  @override
  @JsonKey()
  List<Profile> get paginatedProfiles {
    if (_paginatedProfiles is EqualUnmodifiableListView)
      return _paginatedProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paginatedProfiles);
  }

  /// Lista de usuários selecionados para convite
  final List<Profile> _selectedUsers;

  /// Lista de usuários selecionados para convite
  @override
  @JsonKey()
  List<Profile> get selectedUsers {
    if (_selectedUsers is EqualUnmodifiableListView) return _selectedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedUsers);
  }

  /// Termo de busca atual
  @override
  @JsonKey()
  final String searchQuery;

  /// Número da página atual (para paginação)
  @override
  @JsonKey()
  final int currentPage;

  /// Indica se há mais dados para carregar
  @override
  @JsonKey()
  final bool hasMoreData;

  /// Indica se está carregando mais dados
  @override
  @JsonKey()
  final bool isLoadingMore;

  /// Mensagem de erro, se houver
  @override
  final String? errorMessage;

  /// Mensagem de sucesso, se houver
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'InviteFormState(allProfiles: $allProfiles, paginatedProfiles: $paginatedProfiles, selectedUsers: $selectedUsers, searchQuery: $searchQuery, currentPage: $currentPage, hasMoreData: $hasMoreData, isLoadingMore: $isLoadingMore, errorMessage: $errorMessage, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteFormStateImpl &&
            const DeepCollectionEquality()
                .equals(other._allProfiles, _allProfiles) &&
            const DeepCollectionEquality()
                .equals(other._paginatedProfiles, _paginatedProfiles) &&
            const DeepCollectionEquality()
                .equals(other._selectedUsers, _selectedUsers) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMoreData, hasMoreData) ||
                other.hasMoreData == hasMoreData) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allProfiles),
      const DeepCollectionEquality().hash(_paginatedProfiles),
      const DeepCollectionEquality().hash(_selectedUsers),
      searchQuery,
      currentPage,
      hasMoreData,
      isLoadingMore,
      errorMessage,
      successMessage);

  /// Create a copy of InviteFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteFormStateImplCopyWith<_$InviteFormStateImpl> get copyWith =>
      __$$InviteFormStateImplCopyWithImpl<_$InviteFormStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteFormStateImplToJson(
      this,
    );
  }
}

abstract class _InviteFormState implements InviteFormState {
  const factory _InviteFormState(
      {final List<Profile> allProfiles,
      final List<Profile> paginatedProfiles,
      final List<Profile> selectedUsers,
      final String searchQuery,
      final int currentPage,
      final bool hasMoreData,
      final bool isLoadingMore,
      final String? errorMessage,
      final String? successMessage}) = _$InviteFormStateImpl;

  factory _InviteFormState.fromJson(Map<String, dynamic> json) =
      _$InviteFormStateImpl.fromJson;

  /// Lista de todos os perfis disponíveis
  @override
  List<Profile> get allProfiles;

  /// Lista de perfis paginados e filtrados para exibição
  @override
  List<Profile> get paginatedProfiles;

  /// Lista de usuários selecionados para convite
  @override
  List<Profile> get selectedUsers;

  /// Termo de busca atual
  @override
  String get searchQuery;

  /// Número da página atual (para paginação)
  @override
  int get currentPage;

  /// Indica se há mais dados para carregar
  @override
  bool get hasMoreData;

  /// Indica se está carregando mais dados
  @override
  bool get isLoadingMore;

  /// Mensagem de erro, se houver
  @override
  String? get errorMessage;

  /// Mensagem de sucesso, se houver
  @override
  String? get successMessage;

  /// Create a copy of InviteFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteFormStateImplCopyWith<_$InviteFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
