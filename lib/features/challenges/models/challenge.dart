import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

/// Represents a challenge in the Ray Club application.
/// This model is immutable and uses Freezed for code generation.
@freezed
class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required int reward,
    required List<String> participants,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Challenge;

  /// Creates a Challenge from a JSON map
  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}

/// Estado para gerenciamento do Challenge
@freezed
class ChallengeState with _$ChallengeState {
  const factory ChallengeState({
    @Default([]) List<Challenge> challenges,
    @Default([]) List<Challenge> filteredChallenges,
    Challenge? selectedChallenge,
    @Default([]) List<ChallengeInvite> pendingInvites,
    @Default([]) List<ChallengeProgress> progressList,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? successMessage,
  }) = _ChallengeState;

  /// Estado inicial
  const factory ChallengeState.initial() = _Initial;

  /// Estado de carregamento
  const factory ChallengeState.loading() = _Loading;

  /// Estado de sucesso com dados
  const factory ChallengeState.success({
    required List<Challenge> challenges,
    @Default([]) List<Challenge> filteredChallenges,
    Challenge? selectedChallenge,
    @Default([]) List<ChallengeInvite> pendingInvites,
    @Default([]) List<ChallengeProgress> progressList,
    String? message,
  }) = _Success;

  /// Estado de erro
  const factory ChallengeState.error({
    required String message,
  }) = _Error;
}

/// Status do convite para o desafio
enum InviteStatus { pending, accepted, declined }

/// Modelo para convites de desafios
@freezed
class ChallengeInvite with _$ChallengeInvite {
  const factory ChallengeInvite({
    required String id,
    required String challengeId,
    required String challengeTitle,
    required String inviterId,
    required String inviterName,
    required String inviteeId,
    @Default(InviteStatus.pending) InviteStatus status,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) = _ChallengeInvite;

  /// Cria um ChallengeInvite a partir de um mapa JSON
  factory ChallengeInvite.fromJson(Map<String, dynamic> json) => _$ChallengeInviteFromJson(json);
}

/// Modelo para progresso nos desafios
@freezed
class ChallengeProgress with _$ChallengeProgress {
  const factory ChallengeProgress({
    required String id,
    required String challengeId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required int points,
    required int position,
    required double completionPercentage,
    required DateTime lastUpdated,
  }) = _ChallengeProgress;

  /// Cria um ChallengeProgress a partir de um mapa JSON
  factory ChallengeProgress.fromJson(Map<String, dynamic> json) => _$ChallengeProgressFromJson(json);
} 