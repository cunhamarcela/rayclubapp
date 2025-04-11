// Package imports:
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'challenge_progress.freezed.dart';
// part 'challenge_progress.g.dart';

class ChallengeProgress {
  final String id;
  final String userId;
  final String challengeId;
  final String userName;
  final String? userPhotoUrl;
  final int points;
  final int? checkInsCount;
  final DateTime? lastCheckIn;
  final int? consecutiveDays;
  final bool completed;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Para compatibilidade com código existente
  final int position;
  final double completionPercentage;
  DateTime get lastUpdated => updatedAt ?? createdAt;

  const ChallengeProgress({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.userName,
    this.userPhotoUrl,
    required this.points,
    this.checkInsCount,
    this.lastCheckIn,
    this.consecutiveDays,
    this.completed = false,
    required this.createdAt,
    this.updatedAt,
    this.position = 0,
    this.completionPercentage = 0.0,
  });

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeProgress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      challengeId: json['challenge_id'] as String,
      userName: json['user_name'] as String,
      userPhotoUrl: json['user_photo_url'] as String?,
      points: json['points'] as int? ?? 0,
      checkInsCount: json['check_ins_count'] as int?,
      lastCheckIn: json['last_check_in'] != null 
          ? DateTime.parse(json['last_check_in'] as String) 
          : null,
      consecutiveDays: json['consecutive_days'] as int?,
      completed: json['completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      position: json['position'] as int? ?? 0,
      completionPercentage: json['completion_percentage'] != null
          ? (json['completion_percentage'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'challenge_id': challengeId,
      'user_name': userName,
      'user_photo_url': userPhotoUrl,
      'points': points,
      'check_ins_count': checkInsCount,
      'last_check_in': lastCheckIn?.toIso8601String(),
      'consecutive_days': consecutiveDays,
      'completed': completed,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'position': position,
      'completion_percentage': completionPercentage,
    };
  }
  
  /// Cria uma cópia deste objeto com os campos opcionalmente alterados
  ChallengeProgress copyWith({
    String? id,
    String? userId,
    String? challengeId,
    String? userName,
    String? userPhotoUrl,
    int? points,
    int? checkInsCount,
    DateTime? lastCheckIn,
    int? consecutiveDays,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? position,
    double? completionPercentage,
  }) {
    return ChallengeProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      challengeId: challengeId ?? this.challengeId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      points: points ?? this.points,
      checkInsCount: checkInsCount ?? this.checkInsCount,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      position: position ?? this.position,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}