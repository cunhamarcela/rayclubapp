import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/challenge.dart';
import '../models/challenge_progress.dart';
import '../repositories/challenge_repository.dart';

/// Service for managing Supabase Realtime connections for challenges
class RealtimeChallengeService {
  final SupabaseClient _client;
  final Map<String, StreamSubscription> _subscriptions = {};

  RealtimeChallengeService(this._client);

  /// Subscribe to real-time updates for a challenge's participants
  Stream<List<ChallengeProgress>> watchChallengeParticipants(String challengeId) {
    try {
      return _client
          .from('challenge_progress')
          .stream(primaryKey: ['id'])
          .eq('challenge_id', challengeId)
          .order('points', ascending: false)
          .map((data) {
            if (data is List) {
              return data
                  .map((item) => ChallengeProgress.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
            return <ChallengeProgress>[];
          });
    } catch (e) {
      return Stream.error('Failed to subscribe to challenge participants: $e');
    }
  }

  /// Subscribe to real-time updates for a challenge's details
  Stream<Challenge?> watchChallenge(String challengeId) {
    try {
      return _client
          .from('challenges')
          .stream(primaryKey: ['id'])
          .eq('id', challengeId)
          .map((data) {
            if (data is List && data.isNotEmpty) {
              return Challenge.fromJson(data.first as Map<String, dynamic>);
            }
            return null;
          });
    } catch (e) {
      return Stream.error('Failed to subscribe to challenge: $e');
    }
  }

  /// Subscribe to real-time updates for a user's check-ins in a challenge
  Stream<int> watchUserCheckInsCount(String userId, String challengeId) {
    try {
      return _client
          .from('challenge_check_ins')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .eq('challenge_id', challengeId)
          .map((data) {
            if (data is List) {
              return data.length;
            }
            return 0;
          });
    } catch (e) {
      return Stream.error('Failed to subscribe to user check-ins: $e');
    }
  }

  /// Subscribe to challenges a user is participating in
  Stream<List<Challenge>> watchUserChallenges(String userId) {
    try {
      return _client
          .from('challenges')
          .stream(primaryKey: ['id'])
          .filter('participants', 'cs', '{$userId}')
          .map((data) {
            if (data is List) {
              return data
                  .map((item) => Challenge.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
            return <Challenge>[];
          });
    } catch (e) {
      return Stream.error('Failed to subscribe to user challenges: $e');
    }
  }

  /// Subscribe to real-time updates for a user's progress in a specific challenge
  Stream<ChallengeProgress?> watchUserProgress(String userId, String challengeId) {
    try {
      return _client
          .from('challenge_progress')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .eq('challenge_id', challengeId)
          .map((data) {
            if (data is List && data.isNotEmpty) {
              return ChallengeProgress.fromJson(data.first as Map<String, dynamic>);
            }
            return null;
          });
    } catch (e) {
      return Stream.error('Failed to subscribe to user progress: $e');
    }
  }

  /// Clean up all subscriptions
  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

/// Provider for the RealtimeChallengeService
final realtimeChallengeServiceProvider = Provider<RealtimeChallengeService>((ref) {
  final client = Supabase.instance.client;
  final service = RealtimeChallengeService(client);
  
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Stream provider for watching challenge participants in real-time
final realtimeChallengeParticipantsProvider = StreamProvider.family<List<ChallengeProgress>, String>((ref, challengeId) {
  final service = ref.watch(realtimeChallengeServiceProvider);
  return service.watchChallengeParticipants(challengeId);
});

/// Stream provider for watching a challenge's details in real-time
final realtimeChallengeProvider = StreamProvider.family<Challenge?, String>((ref, challengeId) {
  final service = ref.watch(realtimeChallengeServiceProvider);
  return service.watchChallenge(challengeId);
});

/// Stream provider for watching a user's check-ins count in real-time
final realtimeUserCheckInsProvider = StreamProvider.family<int, UserChallengeParams>((ref, params) {
  final service = ref.watch(realtimeChallengeServiceProvider);
  return service.watchUserCheckInsCount(params.userId, params.challengeId);
});

/// Stream provider for watching a user's progress in a challenge in real-time
final realtimeUserProgressProvider = StreamProvider.family<ChallengeProgress?, UserChallengeParams>((ref, params) {
  final service = ref.watch(realtimeChallengeServiceProvider);
  return service.watchUserProgress(params.userId, params.challengeId);
});

/// Class for holding user and challenge IDs for family providers
class UserChallengeParams {
  final String userId;
  final String challengeId;
  
  const UserChallengeParams({
    required this.userId,
    required this.challengeId,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserChallengeParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          challengeId == other.challengeId;
  
  @override
  int get hashCode => userId.hashCode ^ challengeId.hashCode;
} 