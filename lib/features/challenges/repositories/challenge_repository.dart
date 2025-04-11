// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

// Project imports:
import '../../../core/errors/app_exception.dart';
import '../models/challenge.dart';
import '../models/challenge_progress.dart';
import '../models/challenge_group.dart';
import '../../../utils/text_sanitizer.dart';

/// Provider para o repositório de desafios
final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final client = Supabase.instance.client;
  return SupabaseChallengeRepository(client);
});

/// Interface para operações de repositório de desafios
abstract class ChallengeRepository {
  /// Obtém todos os desafios
  Future<List<Challenge>> getChallenges();
  
  /// Obtém um desafio pelo ID
  Future<Challenge> getChallengeById(String id);
  
  /// Obtém desafios criados por um usuário específico
  Future<List<Challenge>> getUserChallenges(String userId);
  
  /// Obtém desafios ativos (que ainda não terminaram)
  Future<List<Challenge>> getActiveChallenges();
  
  /// Obtém desafios ativos para um usuário específico
  Future<List<Challenge>> getUserActiveChallenges(String userId);
  
  /// Obtém o desafio oficial atual da Ray
  Future<Challenge?> getOfficialChallenge();
  
  /// Obtém todos os desafios oficiais
  Future<List<Challenge>> getOfficialChallenges();
  
  /// Obtém o desafio principal (em destaque)
  Future<Challenge?> getMainChallenge();
  
  /// Cria um novo desafio
  Future<Challenge> createChallenge(Challenge challenge);
  
  /// Atualiza um desafio existente
  Future<void> updateChallenge(Challenge challenge);
  
  /// Exclui um desafio
  Future<void> deleteChallenge(String id);
  
  /// Participa de um desafio
  Future<void> joinChallenge(String challengeId, String userId);
  
  /// Sai de um desafio
  Future<void> leaveChallenge(String challengeId, String userId);
  
  /// Atualiza o progresso de um usuário em um desafio
  Future<void> updateUserProgress(
    {required String challengeId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required int points,
    required double completionPercentage});
    
  /// Obtém o progresso do usuário em um desafio
  Future<ChallengeProgress?> getUserProgress(String challengeId, String userId);
  
  /// Obtém o ranking completo de um desafio
  Future<List<ChallengeProgress>> getChallengeProgress(String challengeId);
  
  /// Obtém um stream de atualizações dos participantes de um desafio
  Stream<List<ChallengeProgress>> watchChallengeParticipants(String challengeId);
  
  /// Obtém os convites de grupos pendentes para um usuário
  Future<List<ChallengeGroupInvite>> getPendingInvites(String userId);
  
  /// Verifica se o usuário atual é um administrador
  Future<bool> isCurrentUserAdmin();
  
  /// Alterna o status de administrador do usuário atual
  Future<void> toggleAdminStatus();
  
  // Métodos novos para grupos
  
  /// Cria um novo grupo para um desafio
  Future<ChallengeGroup> createGroup({
    required String challengeId,
    required String creatorId,
    required String name,
    String? description,
  });
  
  /// Obtém um grupo pelo ID
  Future<ChallengeGroup> getGroupById(String groupId);
  
  /// Obtém todos os grupos que um usuário criou
  Future<List<ChallengeGroup>> getUserCreatedGroups(String userId);
  
  /// Obtém todos os grupos dos quais um usuário é membro
  Future<List<ChallengeGroup>> getUserMemberGroups(String userId);
  
  /// Atualiza informações de um grupo
  Future<void> updateGroup(ChallengeGroup group);
  
  /// Exclui um grupo
  Future<void> deleteGroup(String groupId);
  
  /// Convida um usuário para um grupo
  Future<void> inviteUserToGroup(String groupId, String inviterId, String inviteeId);
  
  /// Responde a um convite de grupo
  Future<void> respondToGroupInvite(String inviteId, bool accept);
  
  /// Remove um usuário de um grupo
  Future<void> removeUserFromGroup(String groupId, String userId);
  
  /// Obtém o ranking de um grupo específico
  Future<List<ChallengeProgress>> getGroupRanking(String groupId);
  
  /// Verifica se o usuário já fez check-in em uma data específica
  Future<bool> hasCheckedInOnDate(String userId, String challengeId, DateTime date);
  
  /// Obtém o número de dias consecutivos de check-in
  Future<int> getConsecutiveDaysCount(String userId, String challengeId);
  
  /// Registra um check-in do usuário no desafio
  Future<void> recordChallengeCheckIn(
    String userId,
    String challengeId,
    DateTime date,
    int points,
    String userName,
    String? userPhotoUrl,
  );
  
  /// Adiciona pontos de bônus para o usuário
  Future<void> addBonusPoints(
    String userId,
    String challengeId,
    int points,
    String reason,
    String userName,
    String? userPhotoUrl,
  );

  /// Envia um convite para um desafio
  Future<void> sendChallengeInvite({
    required String challengeId,
    required String challengeTitle,
    required String inviterId,
    required String inviterName,
    required String inviteeId,
  });
}

/// Implementação do repositório de desafios usando Supabase
class SupabaseChallengeRepository implements ChallengeRepository {
  final SupabaseClient _client;
  
  SupabaseChallengeRepository(this._client);
  
  /// Método privado para sanitizar strings passíveis de NULL - Deprecated, use TextSanitizer
  @Deprecated('Use TextSanitizer.sanitizeNullableText')
  String? _sanitizeNullableString(String? value) {
    return TextSanitizer.sanitizeNullableText(value);
  }
  
  /// Método utilitário central para lidar com diferentes formatos de resposta
  T _processResponse<T>(
    dynamic response, {
    required T Function(Map<String, dynamic> json) fromJsonSingle,
    required T Function(List<dynamic>) fromJsonList,
    required T defaultValue,
  }) {
    if (response == null) {
      return defaultValue;
    }
    
    // Caso 1: Resposta é uma lista de mapas
    if (response is List) {
      return fromJsonList(response);
    }
    
    // Caso 2: Resposta é um único mapa
    if (response is Map<String, dynamic>) {
      final keys = response.keys.join(', ');
      debugPrint('Response is a Map with keys: $keys');
      try {
        // Verifica se o mapa tem uma propriedade data ou items que contenha a lista
        if (response.containsKey('data') && response['data'] is List) {
          debugPrint('Found data list in response');
          final dataList = response['data'] as List;
          return fromJsonList(dataList);
        } else if (response.containsKey('items') && response['items'] is List) {
          debugPrint('Found items list in response');
          final itemsList = response['items'] as List;
          return fromJsonList(itemsList);
        } else {
          // Se o mapa não tem uma lista interna, tenta tratar como um único desafio
          debugPrint('Treating map as a single challenge');
          return fromJsonSingle(response);
        }
      } catch (e) {
        debugPrint('Error processing map response: $e');
        return defaultValue;
      }
    }
    
    // Caso 3: Tipo inesperado
    debugPrint('Unexpected response type: ${response.runtimeType}');
    return defaultValue;
  }
  
  /// Processa resposta para um único Challenge
  Challenge? _processChallengeSingle(dynamic response) {
    return _processResponse<Challenge?>(
      response,
      fromJsonSingle: (json) => Challenge.fromJson(json),
      fromJsonList: (jsonList) => jsonList.isNotEmpty ? Challenge.fromJson(jsonList.first as Map<String, dynamic>) : null,
      defaultValue: null,
    );
  }
  
  /// Processa resposta para uma lista de Challenges
  List<Challenge> _processChallengeList(dynamic response) {
    return _processResponse<List<Challenge>>(
      response,
      fromJsonSingle: (json) => [Challenge.fromJson(json)],
      fromJsonList: (jsonList) {
        debugPrint('Processing list with ${jsonList.length} items');
        return jsonList.map((item) {
          if (item is Map<String, dynamic>) {
            return Challenge.fromJson(item);
          } else {
            debugPrint('Unexpected item type in list: ${item.runtimeType}');
            return null;
          }
        }).whereType<Challenge>().toList();
      },
      defaultValue: [],
    );
  }
  
  /// Processa resposta para um único ChallengeProgress
  ChallengeProgress? _processProgressSingle(dynamic response) {
    return _processResponse<ChallengeProgress?>(
      response,
      fromJsonSingle: (json) => ChallengeProgress.fromJson(json),
      fromJsonList: (jsonList) => jsonList.isNotEmpty ? ChallengeProgress.fromJson(jsonList.first as Map<String, dynamic>) : null,
      defaultValue: null,
    );
  }
  
  /// Processa resposta para uma lista de ChallengeProgress
  List<ChallengeProgress> _processProgressList(dynamic response) {
    return _processResponse<List<ChallengeProgress>>(
      response,
      fromJsonSingle: (json) => [ChallengeProgress.fromJson(json)],
      fromJsonList: (jsonList) => jsonList.map((item) => ChallengeProgress.fromJson(item as Map<String, dynamic>)).toList(),
      defaultValue: [],
    );
  }
  
  /// Método helper para processar com segurança uma resposta que contém datas
  List<DateTime> _processDatesResponse(dynamic response, String dateField) {
    final List<DateTime> dates = [];
    
    if (response == null) return dates;
    
    if (response is List) {
      for (final item in response) {
        if (item is Map && item.containsKey(dateField)) {
          final dateStr = item[dateField];
          if (dateStr is String) {
            try {
              dates.add(DateTime.parse(dateStr));
            } catch (e) {
              debugPrint('Error parsing date: $e');
            }
          }
        }
      }
    } else if (response is Map && response.containsKey(dateField)) {
      final dateStr = response[dateField];
      if (dateStr is String) {
        try {
          dates.add(DateTime.parse(dateStr));
        } catch (e) {
          debugPrint('Error parsing date: $e');
        }
      }
    }
    
    return dates;
  }
  
  /// Método para tratamento padronizado de exceções do PostgreSQL
  DatabaseException _handlePostgrestException(PostgrestException e, String operation) {
    // Registrar detalhes do erro para facilitar depuração
    debugPrint('PostgrestException in $operation: ${e.message}, code: ${e.code}');
    
    if (e.details != null) debugPrint('Details: ${e.details}');
    if (e.hint != null) debugPrint('Hint: ${e.hint}');
    
    // Mapear códigos de erro comuns para mensagens amigáveis
    String errorMessage;
    switch (e.code) {
      case '23505': // unique_violation
        errorMessage = 'Registro duplicado encontrado';
        break;
      case '23503': // foreign_key_violation
        errorMessage = 'Referência inválida a outro registro';
        break;
      case '42P01': // undefined_table
        errorMessage = 'Tabela não encontrada no banco de dados';
        break;
      case '42703': // undefined_column
        errorMessage = 'Campo não encontrado na tabela';
        break;
      case 'PGRST116': // not_found
        errorMessage = 'Registro não encontrado';
        break;
      default:
        errorMessage = 'Erro ao acessar o banco de dados';
    }
    
    return DatabaseException(
      message: '$errorMessage durante a operação: $operation',
      originalError: e,
      code: e.code,
    );
  }
  
  /// Método para tratamento padronizado de exceções gerais
  Exception _handleGenericException(Object e, String operation) {
    debugPrint('Error in $operation: $e');
    
    if (e is DatabaseException || e is ResourceNotFoundException || e is ValidationException) {
      return e as Exception;
    }
    
    return DatabaseException(
      message: 'Falha durante a operação: $operation',
      originalError: e,
    );
  }
  
  @override
  Future<List<Challenge>> getChallenges() async {
    try {
      final response = await _client
          .from('challenges')
          .select();
      
      return _processChallengeList(response);
    } on PostgrestException catch (e) {
      throw _handlePostgrestException(e, 'getChallenges');
    } catch (e) {
      throw _handleGenericException(e, 'getChallenges');
    }
  }
  
  @override
  Future<Challenge> getChallengeById(String id) async {
    try {
      final response = await _client
          .from('challenges')
          .select()
          .eq('id', id)
          .maybeSingle();
      
      final challenge = _processChallengeSingle(response);
      
      if (challenge == null) {
        throw ResourceNotFoundException(
          message: 'Desafio não encontrado',
        );
      }
      
      return challenge;
    } catch (e) {
      debugPrint('Error in getChallengeById: $e');
      if (e is PostgrestException) {
        throw ResourceNotFoundException(
          message: 'Desafio não encontrado',
          originalError: e,
        );
      }
      if (e is ResourceNotFoundException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao buscar desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<Challenge>> getUserChallenges(String userId) async {
    try {
      final response = await _client
          .from('challenges')
          .select()
          .eq('creator_id', userId)
          .order('created_at', ascending: false);
      
      return _processChallengeList(response);
    } catch (e, stackTrace) {
      // Trata o erro e o converte em um tipo de exceção específico para o domínio
      throw DatabaseException(
        message: 'Erro ao obter desafios do usuário',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<List<Challenge>> getActiveChallenges() async {
    try {
      final now = DateTime.now();
      
      final response = await _client
          .from('challenges')
          .select()
          .lte('start_date', now.toIso8601String())  // Já começaram
          .gte('end_date', now.toIso8601String())    // Ainda não terminaram
          .order('start_date', ascending: false);
      
      return _processChallengeList(response);
    } catch (e, stackTrace) {
      throw DatabaseException(
        message: 'Erro ao obter desafios ativos',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<Challenge?> getOfficialChallenge() async {
    try {
      debugPrint('🔍 Buscando desafio oficial...');
      
      // Removido filtro de data para mostrar qualquer desafio oficial ativo ou não
      final response = await _client
          .from('challenges')
          .select()
          .eq('is_official', true)
          .order('created_at', ascending: false)
          .limit(1);
      
      debugPrint('🔍 Resposta da busca: $response');
      
      if (response == null || (response is List && response.isEmpty)) {
        debugPrint('❌ Nenhum desafio oficial encontrado!');
        return null;
      }
      
      debugPrint('✅ Desafio oficial encontrado: ${response[0]['title']}');
      return _processChallengeSingle(response[0]);
    } catch (e) {
      debugPrint('❌ Erro em getOfficialChallenge: $e');
      return null;
    }
  }
  
  @override
  Future<List<Challenge>> getOfficialChallenges() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _client
          .from('challenges')
          .select()
          .eq('is_official', true)
          .gt('end_date', now)
          .order('start_date', ascending: true);
      
      return _processChallengeList(response);
    } catch (e) {
      debugPrint('Error in getOfficialChallenges: $e');
      throw DatabaseException(
        message: 'Falha ao buscar desafios oficiais',
        originalError: e,
      );
    }
  }
  
  @override
  Future<Challenge?> getMainChallenge() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _client
          .from('challenges')
          .select()
          .gt('end_date', now)
          .order('start_date', ascending: true)
          .limit(1);
      
      return _processChallengeSingle(response);
    } catch (e) {
      debugPrint('Error in getMainChallenge: $e');
      throw DatabaseException(
        message: 'Falha ao buscar desafio principal',
        originalError: e,
      );
    }
  }
  
  @override
  Future<Challenge> createChallenge(Challenge challenge) async {
    try {
      final response = await _client
          .from('challenges')
          .insert(challenge.toJson())
          .select()
          .maybeSingle();
      
      final createdChallenge = _processChallengeSingle(response);
      
      if (createdChallenge == null) {
        throw DatabaseException(
          message: 'Falha ao criar desafio: resposta vazia do servidor',
        );
      }
      
      return createdChallenge;
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao criar desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> updateChallenge(Challenge challenge) async {
    try {
      await _client
          .from('challenges')
          .update(challenge.toJson())
          .eq('id', challenge.id);
    } catch (e) {
      if (e is PostgrestException) {
        throw ResourceNotFoundException(
          message: 'Desafio não encontrado',
          originalError: e,
        );
      }
      throw DatabaseException(
        message: 'Falha ao atualizar desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> deleteChallenge(String id) async {
    try {
      await _client
          .from('challenges')
          .delete()
          .eq('id', id);
    } catch (e) {
      if (e is PostgrestException) {
        throw ResourceNotFoundException(
          message: 'Desafio não encontrado',
          originalError: e,
        );
      }
      throw DatabaseException(
        message: 'Falha ao excluir desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> joinChallenge(String challengeId, String userId) async {
    try {
      // Verificar se o desafio existe
      final challenge = await getChallengeById(challengeId);
      
      // Verificar se o usuário já está participando
      final checkResponse = await _client
          .from('challenge_participants')
          .select()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId)
          .maybeSingle();
      
      // Se já existir um registro, não faz nada
      if (checkResponse != null) {
        return;
      }
      
      // Adicionar o usuário como participante
      await _client
          .from('challenge_participants')
          .insert({
            'challenge_id': challengeId,
            'user_id': userId,
            'joined_at': DateTime.now().toIso8601String(),
            'status': 'active',
          });
      
      // Iniciar com registro de progresso zero
      final username = await _getCurrentUsername(userId);
      final userPhotoUrl = await _getCurrentUserPhotoUrl(userId);
      
      await updateUserProgress(
        challengeId: challengeId,
        userId: userId,
        userName: username ?? 'Usuário',
        userPhotoUrl: userPhotoUrl,
        points: 0,
        completionPercentage: 0,
      );
      
    } catch (e) {
      debugPrint('Error in joinChallenge: $e');
      if (e is ResourceNotFoundException || e is ValidationException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao entrar no desafio',
        originalError: e,
      );
    }
  }
  
  // Método para obter o nome do usuário atual
  Future<String?> _getCurrentUsername(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('username, full_name')
          .eq('id', userId)
          .maybeSingle();
      
      if (response != null) {
        return response['full_name'] ?? response['username'];
      }
      return null;
    } catch (e) {
      debugPrint('Error getting username: $e');
      return null;
    }
  }
  
  // Método para obter a URL da foto do usuário
  Future<String?> _getCurrentUserPhotoUrl(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('avatar_url')
          .eq('id', userId)
          .maybeSingle();
      
      if (response != null) {
        return response['avatar_url'];
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user photo URL: $e');
      return null;
    }
  }
  
  @override
  Future<void> leaveChallenge(String challengeId, String userId) async {
    try {
      // Remover da tabela de participantes
      await _client
          .from('challenge_participants')
          .delete()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId);
          
      // Remover das tabelas relacionadas (opcional)
      await _client
          .from('challenge_progress')
          .delete()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId);
      
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao sair do desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> updateUserProgress({
    required String challengeId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required int points,
    required double completionPercentage,
  }) async {
    try {
      // Verifica se já existe um registro de progresso
      final existingResponse = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId)
          .maybeSingle();
          
      final existingProgress = _processProgressSingle(existingResponse);
      
      final progressData = {
        'challenge_id': challengeId,
        'user_id': userId,
        'user_name': userName,
        'user_photo_url': userPhotoUrl,
        'points': points,
        'completion_percentage': completionPercentage,
        'last_updated': DateTime.now().toIso8601String(),
      };
      
      if (existingProgress != null) {
        // Atualiza o registro existente
        await _client
            .from('challenge_progress')
            .update(progressData)
            .eq('id', existingProgress.id);
      } else {
        // Cria um novo registro
        await _client
            .from('challenge_progress')
            .insert(progressData);
      }
      
      // Atualiza as posições de todos os participantes
      await _updateRankings(challengeId);
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao atualizar progresso',
        originalError: e,
      );
    }
  }
  
  // Método auxiliar para atualizar as posições no ranking
  Future<void> _updateRankings(String challengeId) async {
    try {
      // Obtém todos os progressos ordenados por pontos
      final response = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .order('points', ascending: false);
      
      final progressList = _processProgressList(response);
      
      // Atualiza a posição de cada participante
      for (int i = 0; i < progressList.length; i++) {
        await _client
            .from('challenge_progress')
            .update({'position': i + 1})
            .eq('id', progressList[i].id);
      }
    } catch (e) {
      debugPrint('Error in _updateRankings: $e');
      throw DatabaseException(
        message: 'Falha ao atualizar rankings',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<ChallengeProgress>> getChallengeProgress(String challengeId) async {
    try {
      final response = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .order('position', ascending: true);
      
      return _processProgressList(response);
    } catch (e) {
      debugPrint('Error in getChallengeProgress: $e');
      throw DatabaseException(
        message: 'Falha ao buscar ranking do desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<bool> isCurrentUserAdmin() async {
    try {
      // Obtém o usuário atual
      final user = _client.auth.currentUser;
      if (user == null) {
        return false;
      }
      
      // Verifica se o usuário tem a role de admin
      final response = await _client
          .from('user_roles')
          .select()
          .eq('user_id', user.id)
          .eq('role', 'admin')
          .maybeSingle();
          
      return response != null;
    } catch (e) {
      // Em caso de erro, assume que não é admin por segurança
      return false;
    }
  }
  
  @override
  Future<void> toggleAdminStatus() async {
    try {
      // Obtém o usuário atual
      final user = _client.auth.currentUser;
      if (user == null) {
        throw UnauthorizedException(
          message: 'Usuário não autenticado',
        );
      }
      
      // Verifica se o usuário já é admin
      final isAdmin = await isCurrentUserAdmin();
      
      if (isAdmin) {
        // Remove o status de admin
        await _client
            .from('user_roles')
            .delete()
            .eq('user_id', user.id)
            .eq('role', 'admin');
      } else {
        // Adiciona o status de admin
        await _client
            .from('user_roles')
            .insert({
              'user_id': user.id,
              'role': 'admin',
              'created_at': DateTime.now().toIso8601String(),
            });
      }
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao alterar status de administrador',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> updateChallengeProgress({
    required String challengeId,
    required String userId,
    required int pointsToAdd,
  }) async {
    try {
      // Verifica se o desafio existe
      await getChallengeById(challengeId);
      
      // Busca o progresso atual do usuário
      final existingProgressResponse = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId)
          .maybeSingle();
      
      final existingProgress = _processProgressSingle(existingProgressResponse);
      
      if (existingProgress != null) {
        // Calcula os novos pontos
        final currentPoints = existingProgress.points;
        final newPoints = currentPoints + pointsToAdd;
        final currentCompletion = existingProgress.completionPercentage;
        final newCompletion = (currentCompletion + 0.05).clamp(0.0, 1.0);
        
        // Atualiza o progresso
        await _client
            .from('challenge_progress')
            .update({
              'points': newPoints,
              'completion_percentage': newCompletion,
              'last_updated': DateTime.now().toIso8601String(),
            })
            .eq('id', existingProgress.id);
      } else {
        // Busca informações do usuário
        final userInfoResponse = await _client
            .from('users')
            .select('name, photo_url')
            .eq('id', userId)
            .maybeSingle();
        
        String userName = 'Usuário $userId';
        String? userPhotoUrl;
        
        if (userInfoResponse != null && userInfoResponse is Map<String, dynamic>) {
          userName = userInfoResponse['name'] as String? ?? userName;
          userPhotoUrl = userInfoResponse['photo_url'] as String?;
        }
        
        // Cria um novo registro de progresso
        await _client
            .from('challenge_progress')
            .insert({
              'challenge_id': challengeId,
              'user_id': userId,
              'user_name': userName,
              'user_photo_url': userPhotoUrl,
              'points': pointsToAdd,
              'completion_percentage': 0.05,
              'position': 0, // Será atualizado pelo _updateRankings
              'last_updated': DateTime.now().toIso8601String(),
            });
      }
      
      // Atualiza as posições no ranking
      await _updateRankings(challengeId);
    } catch (e) {
      debugPrint('Error in updateChallengeProgress: $e');
      if (e is ResourceNotFoundException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao atualizar progresso do desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Stream<List<ChallengeProgress>> watchChallengeParticipants(String challengeId) {
    try {
      return _client
          .from('challenge_progress')
          .stream(primaryKey: ['id'])
          .eq('challenge_id', challengeId)
          .order('points', ascending: false)
          .map((data) {
            return data
                .map<ChallengeProgress>((json) => ChallengeProgress.fromJson(json))
                .toList();
          });
    } catch (e, stackTrace) {
      debugPrint('Error watching challenge participants: $e');
      throw DatabaseException(
        message: 'Erro ao observar participantes do desafio',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<Challenge>> getUserActiveChallenges(String userId) async {
    try {
      final now = DateTime.now();
      
      // Obter desafios que o usuário participa e que ainda estão ativos
      final response = await _client
          .from('challenge_progress')
          .select('challenge_id, challenges(*)')
          .eq('user_id', userId)
          .gte('challenges.end_date', now.toIso8601String());
      
      if (response == null || response.isEmpty) {
        return [];
      }
      
      // Extrair os desafios da resposta aninhada
      final challenges = <Challenge>[];
      for (final item in (response as List)) {
        if (item['challenges'] != null && item['challenges'] is Map<String, dynamic>) {
          final challenge = Challenge.fromJson(item['challenges'] as Map<String, dynamic>);
          challenges.add(challenge);
        }
      }
      
      return challenges;
    } catch (e, stackTrace) {
      debugPrint('Erro ao obter desafios ativos do usuário: $e');
      throw DatabaseException(
        message: 'Erro ao obter desafios ativos do usuário',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<bool> hasCheckedInOnDate(String userId, String challengeId, DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0]; // Formato YYYY-MM-DD
      
      final response = await _client
          .from('challenge_check_ins')
          .select()
          .eq('user_id', userId)
          .eq('challenge_id', challengeId)
          .ilike('check_in_date', '$dateStr%')
          .limit(1);
      
      return response.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking check-in: $e');
      return false;
    }
  }
  
  @override
  Future<int> getConsecutiveDaysCount(String userId, String challengeId) async {
    try {
      // Esta é uma implementação simplificada. Na prática, você precisaria 
      // implementar uma lógica mais complexa para verificar dias consecutivos
      final response = await _client
          .rpc('get_consecutive_days', params: {
            'p_user_id': userId,
            'p_challenge_id': challengeId,
          });
      
      return response ?? 0;
    } catch (e) {
      debugPrint('Error getting consecutive days: $e');
      return 0;
    }
  }
  
  @override
  Future<void> recordChallengeCheckIn(
    String userId,
    String challengeId,
    DateTime date,
    int points,
    String userName,
    String? userPhotoUrl,
  ) async {
    try {
      // Registrar o check-in
      await _client.from('challenge_check_ins').insert({
        'user_id': userId,
        'challenge_id': challengeId,
        'check_in_date': date.toIso8601String(),
        'points': points,
      });
      
      // Atualizar o progresso do usuário
      await updateUserProgress(
        challengeId: challengeId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        points: points,
        completionPercentage: 0, // Será calculado no backend
      );
    } catch (e) {
      debugPrint('Error recording check-in: $e');
      throw AppException(
        message: 'Erro ao registrar check-in: $e',
        code: 'checkin_error',
      );
    }
  }
  
  @override
  Future<void> addBonusPoints(
    String userId,
    String challengeId,
    int points,
    String reason,
    String userName,
    String? userPhotoUrl,
  ) async {
    try {
      // Registrar os pontos de bônus
      await _client.from('challenge_bonus_points').insert({
        'user_id': userId,
        'challenge_id': challengeId,
        'points': points,
        'reason': reason,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Atualizar o progresso do usuário
      await updateUserProgress(
        challengeId: challengeId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        points: points,
        completionPercentage: 0, // Será calculado no backend
      );
    } catch (e) {
      debugPrint('Error adding bonus points: $e');
      throw AppException(
        message: 'Erro ao adicionar pontos de bônus: $e',
        code: 'bonus_points_error',
      );
    }
  }
  
  @override
  Future<ChallengeProgress?> getUserProgress(String challengeId, String userId) async {
    try {
      final response = await _client
          .from('challenge_progress')
          .select()
          .eq('user_id', userId)
          .eq('challenge_id', challengeId)
          .single();
          
      if (response == null) {
        return null;
      }
      
      return ChallengeProgress.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException in getUserProgress: ${e.message}, code: ${e.code}');
      
      // Log mais detalhado para erros Postgres
      if (e.details != null) debugPrint('Details: ${e.details}');
      if (e.hint != null) debugPrint('Hint: ${e.hint}');
      
      // Se não encontrar nenhum registro, retornar null em vez de lançar exceção
      if (e.code == 'PGRST116') {
        return null;
      }
      
      // Erro de tabela não existente também não deve ser fatal
      if (e.code == '42P01' || e.message.contains('does not exist')) {
        return null;
      }
      
      throw DatabaseException(
        message: 'Falha ao buscar progresso do usuário no desafio',
        originalError: e,
        code: e.code,
      );
    } catch (e) {
      debugPrint('Error in getUserProgress: $e');
      
      // Para erros desconhecidos, retornar null para não quebrar funcionalidades dependentes
      return null;
    }
  }

  // Método auxiliar para verificar se as tabelas necessárias existem
  Future<bool> _verifyRequiredTables() async {
    try {
      // Lista de tabelas que devem existir
      final requiredTables = [
        'challenges',
        'challenge_participants',
        'challenge_check_ins',
        'challenge_progress',
        'challenge_bonuses',
      ];
      
      bool allTablesExist = true;
      
      for (final table in requiredTables) {
        try {
          // Tentar executar uma consulta simples em cada tabela
          await _client
              .from(table)
              .select('id')
              .limit(1);
        } catch (e) {
          if (e is PostgrestException && (e.code == '42P01' || e.message.contains('does not exist'))) {
            debugPrint('Tabela $table não existe!');
            allTablesExist = false;
            break;
          }
        }
      }
      
      return allTablesExist;
    } catch (e) {
      debugPrint('Erro ao verificar tabelas: $e');
      return false;
    }
  }

  // Método para ajudar na inicialização do banco de dados
  Future<bool> initializeDatabaseIfNeeded() async {
    if (!(await _verifyRequiredTables())) {
      if (kDebugMode) {
        debugPrint('Tabelas necessárias não encontradas. Tentando criar...');
        try {
          // Chamar procedimento SQL para criar tabelas
          await _client.rpc('initialize_challenge_tables');
          debugPrint('Tabelas criadas com sucesso!');
          return true;
        } catch (e) {
          debugPrint('Falha ao criar tabelas: $e');
          return false;
        }
      }
      return false;
    }
    return true;
  }

  void _logResponseType(dynamic response) {
    if (response is List) {
      debugPrint('Response is List with ${response.length} items');
    } else if (response is Map<String, dynamic>) {
      final keys = response.keys.join(', ');
      debugPrint('Response is Map with keys: $keys');
    } else {
      debugPrint('Response is of type: ${response.runtimeType}');
    }
  }

  @override
  Future<ChallengeGroup> createGroup({
    required String challengeId,
    required String creatorId,
    required String name,
    String? description,
  }) async {
    try {
      // Criar um novo grupo
      final groupData = {
        'challenge_id': challengeId,
        'creator_id': creatorId,
        'name': TextSanitizer.sanitizeText(name),
        'description': description != null ? TextSanitizer.sanitizeText(description) : null,
        'member_ids': [creatorId], // O criador é automaticamente um membro
        'pending_invite_ids': [],
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _client
          .from('challenge_groups')
          .insert(groupData)
          .select()
          .single();
      
      return ChallengeGroup.fromJson(response);
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao criar grupo',
        originalError: e,
      );
    }
  }

  @override
  Future<ChallengeGroup> getGroupById(String groupId) async {
    try {
      final response = await _client
          .from('challenge_groups')
          .select()
          .eq('id', groupId)
          .single();
      
      return ChallengeGroup.fromJson(response);
    } catch (e) {
      if (e is PostgrestException) {
        throw ResourceNotFoundException(
          message: 'Grupo não encontrado',
          originalError: e,
        );
      }
      throw DatabaseException(
        message: 'Falha ao buscar grupo',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ChallengeGroup>> getUserCreatedGroups(String userId) async {
    try {
      final response = await _client
          .from('challenge_groups')
          .select()
          .eq('creator_id', userId)
          .order('created_at', ascending: false);
      
      if (response == null || (response is List && response.isEmpty)) {
        return [];
      }
      
      return (response as List).map((data) => ChallengeGroup.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar grupos criados pelo usuário',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ChallengeGroup>> getUserMemberGroups(String userId) async {
    try {
      // Para PostgreSQL, podemos usar a função de array 'contains'
      final response = await _client
          .from('challenge_groups')
          .select()
          .contains('member_ids', [userId])
          .order('created_at', ascending: false);
      
      if (response == null || (response is List && response.isEmpty)) {
        return [];
      }
      
      return (response as List).map((data) => ChallengeGroup.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar grupos dos quais o usuário é membro',
        originalError: e,
      );
    }
  }

  @override
  Future<void> updateGroup(ChallengeGroup group) async {
    try {
      // Atualizar dados do grupo
      final updateData = {
        'name': group.name,
        'description': group.description,
        'member_ids': group.memberIds,
        'pending_invite_ids': group.pendingInviteIds,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      await _client
          .from('challenge_groups')
          .update(updateData)
          .eq('id', group.id);
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao atualizar grupo',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      // Verificar se o grupo existe
      await getGroupById(groupId);
      
      // Excluir o grupo
      await _client
          .from('challenge_groups')
          .delete()
          .eq('id', groupId);
    } catch (e) {
      if (e is ResourceNotFoundException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao excluir grupo',
        originalError: e,
      );
    }
  }

  @override
  Future<void> inviteUserToGroup(String groupId, String inviterId, String inviteeId) async {
    try {
      // Verificar se o grupo existe
      final group = await getGroupById(groupId);
      
      // Verificar se o usuário convidado já é membro ou já tem convite pendente
      if (group.memberIds.contains(inviteeId)) {
        throw ValidationException(
          message: 'Usuário já é membro deste grupo',
        );
      }
      
      if (group.pendingInviteIds.contains(inviteeId)) {
        throw ValidationException(
          message: 'Usuário já possui um convite pendente para este grupo',
        );
      }
      
      // Obter informações dos usuários
      final inviterData = await _client
          .from('profiles')
          .select('full_name')
          .eq('id', inviterId)
          .single();
      
      final inviterName = inviterData['full_name'] as String? ?? 'Usuário';
      
      // Criar convite
      final inviteData = {
        'group_id': groupId,
        'group_name': group.name,
        'inviter_id': inviterId,
        'inviter_name': TextSanitizer.sanitizeText(inviterName),
        'invitee_id': inviteeId,
        'status': InviteStatus.pending.index,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      await _client
          .from('challenge_group_invites')
          .insert(inviteData);
      
      // Adicionar à lista de convites pendentes do grupo
      final updatedPendingInvites = [...group.pendingInviteIds, inviteeId];
      
      // Atualizar o grupo com o novo convite pendente
      await _client
          .from('challenge_groups')
          .update({'pending_invite_ids': updatedPendingInvites})
          .eq('id', groupId);
    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao convidar usuário para o grupo',
        originalError: e,
      );
    }
  }

  @override
  Future<void> respondToGroupInvite(String inviteId, bool accept) async {
    try {
      // Verificar se o convite existe e está pendente
      final response = await _client
          .from('challenge_group_invites')
          .select()
          .eq('id', inviteId)
          .single();
      
      if (response == null) {
        throw const AppException(
          message: 'Convite não encontrado',
          code: 'invite_not_found',
        );
      }
      
      final inviteStatus = accept ? 'accepted' : 'declined';
      
      // Atualizar status do convite
      await _client
          .from('challenge_group_invites')
          .update({
            'status': inviteStatus,
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('id', inviteId);
      
      // Se aceito, adicionar o usuário ao grupo
      if (accept) {
        final String groupId = response['group_id'];
        final String inviteeId = response['invitee_id'];
        
        // Buscar o grupo para verificar se o usuário já é membro
        final groupResponse = await _client
            .from('challenge_groups')
            .select('member_ids')
            .eq('id', groupId)
            .single();
        
        if (groupResponse != null) {
          List<String> memberIds = List<String>.from(groupResponse['member_ids'] ?? []);
          
          // Adicionar usuário se ainda não for membro
          if (!memberIds.contains(inviteeId)) {
            memberIds.add(inviteeId);
            
            await _client
                .from('challenge_groups')
                .update({
                  'member_ids': memberIds,
                  'updated_at': DateTime.now().toIso8601String(),
                })
                .eq('id', groupId);
          }
        }
      }
    } catch (e) {
      throw AppException(
        message: 'Erro ao responder ao convite: $e',
        code: 'response_failed',
      );
    }
  }

  @override
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    try {
      // Buscar o grupo
      final groupResponse = await _client
          .from('challenge_groups')
          .select()
          .eq('id', groupId)
          .single();
      
      final group = ChallengeGroup.fromJson(groupResponse);
      
      // Verificar se o usuário é o criador
      if (group.creatorId == userId) {
        throw ValidationException(
          message: 'O criador do grupo não pode ser removido',
        );
      }
      
      // Verificar se o usuário é membro
      if (!group.memberIds.contains(userId)) {
        throw ValidationException(
          message: 'Usuário não é membro deste grupo',
        );
      }
      
      // Remover da lista de membros
      final updatedMembers = group.memberIds.where((id) => id != userId).toList();
      
      // Atualizar o grupo
      await _client
          .from('challenge_groups')
          .update({
            'member_ids': updatedMembers,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', groupId);
    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao remover usuário do grupo',
        originalError: e,
      );
    }
  }

  /// Busca o ranking de um grupo específico de desafio
  @override
  Future<List<ChallengeProgress>> getGroupRanking(String groupId) async {
    try {
      debugPrint('🔍 Buscando grupo: $groupId');
      
      // Verificar se o grupo existe
      final groupResponse = await _client
          .from('challenge_groups')
          .select()
          .eq('id', groupId)
          .single();
      
      if (groupResponse == null) {
        debugPrint('⚠️ Grupo não encontrado: $groupId');
        throw DatabaseException(
          message: 'Grupo não encontrado',
          code: 'group_not_found',
        );
      }
      
      final group = ChallengeGroup.fromJson(groupResponse);
      
      // Buscar membros do grupo
      final members = await _client
          .from('challenge_group_members')
          .select('user_id')
          .eq('group_id', groupId)
          .eq('status', 'accepted');
      
      final userIds = members.map((member) => member['user_id'] as String).toList();
      
      if (userIds.isEmpty) {
        debugPrint('ℹ️ Grupo sem membros: $groupId');
        return [];
      }
      
      // Buscar o desafio associado ao grupo
      final challenge = await getChallengeById(group.challengeId);
      
      // Buscar o progresso de todos os membros
      final progressList = <ChallengeProgress>[];
      
      for (final memberId in userIds) {
        final progress = await getUserProgress(challenge.id, memberId);
        if (progress != null) {
          progressList.add(progress);
        }
      }
      
      // Ordenar por pontos (do maior para o menor)
      progressList.sort((a, b) => b.points.compareTo(a.points));
      
      // Atualizar a posição de cada usuário no ranking
      for (int i = 0; i < progressList.length; i++) {
        progressList[i] = progressList[i].copyWith(position: i + 1);
      }
      
      return progressList;
    } catch (e) {
      if (e.toString().contains('Grupo não encontrado')) {
        debugPrint('⚠️ Grupo não encontrado: $groupId');
        throw DatabaseException(
          message: 'Grupo não encontrado',
          code: 'group_not_found',
        );
      }
      
      debugPrint('❌ Erro ao buscar ranking do grupo: $e');
      throw DatabaseException(
        message: 'Erro ao buscar ranking do grupo: $e',
        code: 'group_ranking_error',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ChallengeGroupInvite>> getPendingInvites(String userId) async {
    try {
      // Buscar convites pendentes onde o usuário é o convidado
      final response = await _client
          .from('challenge_group_invites')
          .select()
          .eq('invitee_id', userId)
          .eq('status', InviteStatus.pending.index)
          .order('created_at', ascending: false);
      
      if (response == null) {
        return [];
      }
      
      // Converter resultados em convites de grupo
      return (response as List)
          .map((data) => ChallengeGroupInvite.fromJson(data))
          .toList();
    } catch (e) {
      throw AppException(
        message: 'Erro ao carregar convites pendentes: $e',
        code: 'fetch_invites_failed',
      );
    }
  }

  @override
  Future<void> sendChallengeInvite({
    required String challengeId,
    required String challengeTitle,
    required String inviterId,
    required String inviterName,
    required String inviteeId,
  }) async {
    try {
      // Verificar se o desafio existe
      final challenge = await getChallengeById(challengeId);
      
      // Verificar se o usuário convidado já é participante
      if (challenge.participants.contains(inviteeId)) {
        throw ValidationException(
          message: 'Usuário já é participante deste desafio',
        );
      }
      
      // Verificar se já existe um convite pendente
      final pendingInvites = await _client
          .from('challenge_invites')
          .select()
          .eq('challenge_id', challengeId)
          .eq('invitee_id', inviteeId)
          .eq('status', InviteStatus.pending.index);
      
      if (pendingInvites != null && (pendingInvites as List).isNotEmpty) {
        throw ValidationException(
          message: 'Usuário já possui um convite pendente para este desafio',
        );
      }
      
      // Criar convite
      final inviteData = {
        'challenge_id': challengeId,
        'challenge_title': challengeTitle,
        'inviter_id': inviterId,
        'inviter_name': TextSanitizer.sanitizeText(inviterName),
        'invitee_id': inviteeId,
        'status': InviteStatus.pending.index,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      await _client
          .from('challenge_invites')
          .insert(inviteData);
          
    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao convidar usuário para o desafio',
        originalError: e,
      );
    }
  }
} 
