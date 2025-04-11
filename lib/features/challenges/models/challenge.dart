// Dart imports:
import 'dart:convert';
import 'package:flutter/foundation.dart';

// Package imports:
import 'dart:collection';

// Project imports:
import 'challenge_progress.dart';
import 'challenge_group.dart';
import '../../../utils/text_sanitizer.dart';

/// Represents a challenge in the Ray Club application.
class Challenge {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final int points;
  final List<String>? requirements;
  final List<String> participants;
  final bool active;
  final String? creatorId;
  final bool isOfficial;
  final List<String>? invitedUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Alias para compatibilidade com código existente
  int get reward => points;

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.type = 'daily',
    this.points = 10,
    this.requirements,
    this.participants = const [],
    this.active = true,
    this.creatorId,
    this.isOfficial = false,
    this.invitedUsers,
    this.createdAt,
    this.updatedAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    // Processar campos que podem vir como JSON string ou já como objeto
    List<String>? requirementsList;
    var requirements = json['requirements'];
    if (requirements != null) {
      if (requirements is String) {
        try {
          requirements = jsonDecode(requirements);
        } catch (e) {
          debugPrint('Error parsing requirements string: $e');
        }
      }
      
      if (requirements is List) {
        requirementsList = requirements.map((item) => item.toString()).toList();
      } else if (requirements is Map) {
        // Se for um objeto JSON, converter cada campo para string
        requirementsList = requirements.entries
            .map((entry) => "${entry.key}: ${entry.value}")
            .toList();
      }
    }
    
    // Handle participants field which can be an integer, string, array, or null
    List<String> participantsList = [];
    var participants = json['participants'];
    if (participants != null) {
      if (participants is int) {
        // Se for um inteiro (contagem), criar uma lista vazia
        // Podemos apenas registrar o número para debug
        debugPrint('Challenge has $participants participants');
      } else if (participants is String) {
        try {
          var decoded = jsonDecode(participants);
          if (decoded is List) {
            participantsList = decoded.map((item) => item.toString()).toList();
          }
        } catch (e) {
          debugPrint('Error parsing participants string: $e');
        }
      } else if (participants is List) {
        participantsList = participants.map((item) => item.toString()).toList();
      }
    }
    
    // Handle invited_users field which can be a string, array, or even empty/null
    List<String>? invitedUsersList;
    var invitedUsers = json['invited_users'];
    if (invitedUsers != null) {
      if (invitedUsers is String) {
        try {
          var decoded = jsonDecode(invitedUsers);
          if (decoded is List) {
            invitedUsersList = decoded.map((item) => item.toString()).toList();
          }
        } catch (e) {
          debugPrint('Error parsing invited_users: $e');
        }
      } else if (invitedUsers is List) {
        invitedUsersList = invitedUsers.map((item) => item.toString()).toList();
      }
    }
    
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      type: json['type'] as String? ?? 'daily',
      points: json['points'] as int? ?? 10,
      requirements: requirementsList,
      participants: participantsList,
      active: json['active'] as bool? ?? true,
      creatorId: json['creator_id'] as String?,
      isOfficial: json['is_official'] as bool? ?? false,
      invitedUsers: invitedUsersList,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'type': type,
      'points': points,
      'requirements': requirements,
      'active': active,
    };
    
    // Adicionando campos opcionais apenas se não forem nulos
    if (creatorId != null) data['creator_id'] = creatorId;
    if (participants.isNotEmpty) data['participants'] = participants;
    data['is_official'] = isOfficial;
    if (invitedUsers != null) data['invited_users'] = invitedUsers;
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();
    
    return data;
  }

  /// Cria uma cópia do Challenge com campos opcionalmente alterados
  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    int? points,
    List<String>? requirements,
    List<String>? participants,
    bool? active,
    String? creatorId,
    bool? isOfficial,
    List<String>? invitedUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      points: points ?? this.points,
      requirements: requirements ?? this.requirements,
      participants: participants ?? this.participants,
      active: active ?? this.active,
      creatorId: creatorId ?? this.creatorId,
      isOfficial: isOfficial ?? this.isOfficial,
      invitedUsers: invitedUsers ?? this.invitedUsers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Estado para gerenciamento do Challenge
class ChallengeState {
  final List<Challenge> challenges;
  final List<Challenge> filteredChallenges;
  final Challenge? selectedChallenge;
  final List<ChallengeGroupInvite> pendingInvites;
  final List<ChallengeProgress> progressList;
  final ChallengeProgress? userProgress;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final Challenge? officialChallenge;

  ChallengeState({
    this.challenges = const [],
    this.filteredChallenges = const [],
    this.selectedChallenge,
    this.pendingInvites = const [],
    this.progressList = const [],
    this.userProgress,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.officialChallenge,
  });
  
  /// Cria uma cópia do estado com as propriedades especificadas alteradas
  ChallengeState copyWith({
    List<Challenge>? challenges,
    List<Challenge>? filteredChallenges,
    Challenge? selectedChallenge,
    List<ChallengeGroupInvite>? pendingInvites,
    List<ChallengeProgress>? progressList,
    ChallengeProgress? userProgress,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    Challenge? officialChallenge,
  }) {
    return ChallengeState(
      challenges: challenges ?? this.challenges,
      filteredChallenges: filteredChallenges ?? this.filteredChallenges,
      selectedChallenge: selectedChallenge ?? this.selectedChallenge,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      progressList: progressList ?? this.progressList,
      userProgress: userProgress ?? this.userProgress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      officialChallenge: officialChallenge ?? this.officialChallenge,
    );
  }

  /// Creates initial state
  factory ChallengeState.initial() => ChallengeState();

  /// Creates loading state
  factory ChallengeState.loading({
    List<Challenge> challenges = const [],
    List<Challenge> filteredChallenges = const [],
    Challenge? selectedChallenge,
    List<ChallengeGroupInvite> pendingInvites = const [],
    List<ChallengeProgress> progressList = const [],
    ChallengeProgress? userProgress,
    Challenge? officialChallenge,
  }) => ChallengeState(
    challenges: challenges,
    filteredChallenges: filteredChallenges,
    selectedChallenge: selectedChallenge,
    pendingInvites: pendingInvites,
    progressList: progressList,
    userProgress: userProgress,
    officialChallenge: officialChallenge,
    isLoading: true,
  );

  /// Creates success state
  factory ChallengeState.success({
    required List<Challenge> challenges,
    List<Challenge> filteredChallenges = const [],
    Challenge? selectedChallenge,
    List<ChallengeGroupInvite> pendingInvites = const [],
    List<ChallengeProgress> progressList = const [],
    ChallengeProgress? userProgress,
    Challenge? officialChallenge,
    String? message,
  }) => ChallengeState(
    challenges: challenges,
    filteredChallenges: filteredChallenges,
    selectedChallenge: selectedChallenge,
    pendingInvites: pendingInvites,
    progressList: progressList,
    userProgress: userProgress,
    officialChallenge: officialChallenge,
    successMessage: message,
  );

  /// Creates error state
  factory ChallengeState.error({
    List<Challenge> challenges = const [],
    List<Challenge> filteredChallenges = const [],
    Challenge? selectedChallenge,
    List<ChallengeGroupInvite> pendingInvites = const [],
    List<ChallengeProgress> progressList = const [],
    ChallengeProgress? userProgress,
    Challenge? officialChallenge,
    required String message,
  }) => ChallengeState(
    challenges: challenges,
    filteredChallenges: filteredChallenges,
    selectedChallenge: selectedChallenge,
    pendingInvites: pendingInvites,
    progressList: progressList,
    userProgress: userProgress,
    officialChallenge: officialChallenge,
    errorMessage: message,
  );
}

/// Status do convite para o desafio
enum InviteStatus { pending, accepted, declined }

/// Modelo para convites de desafios (DEPRECATED - Use ChallengeGroupInvite instead)
@Deprecated('Use ChallengeGroupInvite em vez de ChallengeInvite')
class ChallengeInvite {
  final String id;
  final String challengeId;
  final String challengeTitle;
  final String inviterId;
  final String inviterName;
  final String inviteeId;
  final InviteStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const ChallengeInvite({
    required this.id,
    required this.challengeId,
    required this.challengeTitle,
    required this.inviterId,
    required this.inviterName,
    required this.inviteeId,
    this.status = InviteStatus.pending,
    required this.createdAt,
    this.respondedAt,
  });

  /// Cria um ChallengeInvite a partir de um mapa JSON
  factory ChallengeInvite.fromJson(Map<String, dynamic> json) {
    return ChallengeInvite(
      id: json['id'] as String,
      challengeId: json['challenge_id'] as String,
      challengeTitle: json['challenge_title'] as String,
      inviterId: json['inviter_id'] as String,
      inviterName: json['inviter_name'] as String,
      inviteeId: json['invitee_id'] as String,
      status: InviteStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['created_at'] as String),
      respondedAt: json['responded_at'] != null ? DateTime.parse(json['responded_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'challenge_title': challengeTitle,
      'inviter_id': inviterId,
      'inviter_name': inviterName,
      'invitee_id': inviteeId,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
    };
  }
} 
