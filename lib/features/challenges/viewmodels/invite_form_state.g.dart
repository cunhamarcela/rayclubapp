// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_form_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InviteFormStateImpl _$$InviteFormStateImplFromJson(
        Map<String, dynamic> json) =>
    _$InviteFormStateImpl(
      allProfiles: (json['allProfiles'] as List<dynamic>?)
              ?.map((e) => Profile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      paginatedProfiles: (json['paginatedProfiles'] as List<dynamic>?)
              ?.map((e) => Profile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedUsers: (json['selectedUsers'] as List<dynamic>?)
              ?.map((e) => Profile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      searchQuery: json['searchQuery'] as String? ?? '',
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      hasMoreData: json['hasMoreData'] as bool? ?? true,
      isLoadingMore: json['isLoadingMore'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
      successMessage: json['successMessage'] as String?,
    );

Map<String, dynamic> _$$InviteFormStateImplToJson(
        _$InviteFormStateImpl instance) =>
    <String, dynamic>{
      'allProfiles': instance.allProfiles,
      'paginatedProfiles': instance.paginatedProfiles,
      'selectedUsers': instance.selectedUsers,
      'searchQuery': instance.searchQuery,
      'currentPage': instance.currentPage,
      'hasMoreData': instance.hasMoreData,
      'isLoadingMore': instance.isLoadingMore,
      'errorMessage': instance.errorMessage,
      'successMessage': instance.successMessage,
    };
