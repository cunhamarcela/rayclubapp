import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/sub_challenge.dart';
import '../core/di/base_repository.dart';
import '../core/exceptions/repository_exception.dart';

/// Enum para tipos de moderação
enum ModerationType { approve, reject, flag }

/// Interface para operações relacionadas a sub-desafios
abstract class ISubChallengeRepository {
  Future<List<SubChallenge>> getSubChallenges(String parentChallengeId);
  Future<SubChallenge> getSubChallenge(String id);
  Future<SubChallenge> createSubChallenge(SubChallenge challenge);
  Future<SubChallenge> updateSubChallenge(String id, Map<String, dynamic> data);
  Future<void> deleteSubChallenge(String id);
  Future<void> validateParticipation(String userId, String subChallengeId);
  Future<void> moderateSubChallenge(
      String subChallengeId, ModerationType action);
}

/// Implementação do repositório para sub-desafios
class SubChallengeRepository
    implements ISubChallengeRepository, BaseRepository {
  final supabase.SupabaseClient _supabaseClient;

  SubChallengeRepository(this._supabaseClient);

  @override
  Future<void> initialize() async {
    // Inicialização se necessário
  }

  @override
  Future<List<SubChallenge>> getSubChallenges(String parentChallengeId) async {
    try {
      final response = await _supabaseClient
          .from('sub_challenges')
          .select()
          .eq('parent_challenge_id', parentChallengeId)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((data) => SubChallenge.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to get sub-challenges: ${e.toString()}');
    }
  }

  @override
  Future<SubChallenge> getSubChallenge(String id) async {
    try {
      final response = await _supabaseClient
          .from('sub_challenges')
          .select()
          .eq('id', id)
          .single();

      return SubChallenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('Sub-challenge not found');
      }
      throw DatabaseException('Failed to get sub-challenge: ${e.toString()}');
    }
  }

  @override
  Future<SubChallenge> createSubChallenge(SubChallenge challenge) async {
    try {
      final response = await _supabaseClient
          .from('sub_challenges')
          .insert(challenge.toJson())
          .select()
          .single();

      return SubChallenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw DatabaseException(
          'Failed to create sub-challenge: ${e.toString()}');
    }
  }

  @override
  Future<SubChallenge> updateSubChallenge(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _supabaseClient
          .from('sub_challenges')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return SubChallenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('Sub-challenge not found');
      }
      throw DatabaseException(
          'Failed to update sub-challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSubChallenge(String id) async {
    try {
      await _supabaseClient.from('sub_challenges').delete().eq('id', id);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('Sub-challenge not found');
      }
      throw DatabaseException(
          'Failed to delete sub-challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> validateParticipation(
      String userId, String subChallengeId) async {
    try {
      // Obter o sub-desafio atual
      final challenge = await getSubChallenge(subChallengeId);

      // Verificar se o usuário já é participante
      if (challenge.participants.contains(userId)) {
        throw ValidationException('User is already a participant');
      }

      // Adicionar o usuário à lista de participantes
      final participants = [...challenge.participants, userId];

      // Atualizar o sub-desafio
      await updateSubChallenge(subChallengeId, {'participants': participants});
    } catch (e) {
      if (e is ValidationException) {
        throw e;
      }
      throw DatabaseException(
          'Failed to validate participation: ${e.toString()}');
    }
  }

  @override
  Future<void> moderateSubChallenge(
      String subChallengeId, ModerationType action) async {
    try {
      switch (action) {
        case ModerationType.approve:
          await updateSubChallenge(
              subChallengeId, {'status': SubChallengeStatus.active.index});
          break;
        case ModerationType.reject:
          await updateSubChallenge(
              subChallengeId, {'status': SubChallengeStatus.moderated.index});
          break;
        case ModerationType.flag:
          // Adicionar lógica específica para flag
          await updateSubChallenge(subChallengeId,
              {'status': SubChallengeStatus.moderated.index, 'flagged': true});
          break;
      }
    } catch (e) {
      throw DatabaseException(
          'Failed to moderate sub-challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    // Limpeza de cache se implementado
  }

  @override
  Future<void> dispose() async {
    // Limpeza se necessário
  }
}
