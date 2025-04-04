import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/challenge.dart';
import '../core/di/base_repository.dart';
import '../core/exceptions/repository_exception.dart';

abstract class IChallengeRepository {
  Future<List<Challenge>> getChallenges();
  Future<Challenge> getChallenge(String id);
  Future<Challenge> createChallenge(Challenge challenge);
  Future<Challenge> updateChallenge(String id, Map<String, dynamic> data);
  Future<void> deleteChallenge(String id);
}

class ChallengeRepository implements IChallengeRepository, BaseRepository {
  final supabase.SupabaseClient _supabaseClient;

  ChallengeRepository(this._supabaseClient);

  @override
  Future<void> initialize() async {
    // Inicialização se necessário
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    try {
      final response = await _supabaseClient
          .from('challenges')
          .select()
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((data) => Challenge.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching challenges: $e');
      
      // Verificar se é um erro de coluna não existente
      if (e.toString().contains('challenges.created_at does not exist')) {
        print('Returning mock challenges due to database schema mismatch');
        // Fornecer dados fictícios temporários
        return _getMockChallenges();
      }
      
      throw DatabaseException('Failed to get challenges: ${e.toString()}');
    }
  }
  
  // Dados temporários para uso enquanto a estrutura do banco não está pronta
  List<Challenge> _getMockChallenges() {
    final now = DateTime.now();
    
    return [
      Challenge(
        id: '1',
        title: 'Desafio 30 Dias',
        description: 'Complete 30 dias de treino consecutivos',
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        reward: 500,
        participants: ['user1', 'user2'],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      Challenge(
        id: '2',
        title: 'Maratona Fitness',
        description: 'Acumule 100km em corridas durante o mês',
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        reward: 800,
        participants: ['user3'],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
    ];
  }

  @override
  Future<Challenge> getChallenge(String id) async {
    try {
      final response = await _supabaseClient
          .from('challenges')
          .select()
          .eq('id', id)
          .single();

      return Challenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('Challenge not found');
      }
      throw DatabaseException('Failed to get challenge: ${e.toString()}');
    }
  }

  @override
  Future<Challenge> createChallenge(Challenge challenge) async {
    try {
      final response = await _supabaseClient
          .from('challenges')
          .insert(challenge.toJson())
          .select()
          .single();

      return Challenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw DatabaseException('Failed to create challenge: ${e.toString()}');
    }
  }

  @override
  Future<Challenge> updateChallenge(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _supabaseClient
          .from('challenges')
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return Challenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('Challenge not found');
      }
      throw DatabaseException('Failed to update challenge: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteChallenge(String id) async {
    try {
      await _supabaseClient.from('challenges').delete().eq('id', id);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('Challenge not found');
      }
      throw DatabaseException('Failed to delete challenge: ${e.toString()}');
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
