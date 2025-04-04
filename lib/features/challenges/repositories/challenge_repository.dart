import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/app_exception.dart';
import '../models/challenge.dart';

/// Provider para o repositório de desafios
final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final client = Supabase.instance.client;
  return MockChallengeRepository(client);
  // TODO: Substituir por implementação real quando a estrutura do banco estiver pronta
  // return SupabaseChallengeRepository(client);
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
  
  /// Obtém o desafio oficial atual da Ray
  Future<Challenge?> getOfficialChallenge();
  
  /// Obtém o desafio principal (em destaque)
  Future<Challenge?> getMainChallenge();
  
  /// Cria um novo desafio
  Future<Challenge> createChallenge(Challenge challenge);
  
  /// Atualiza um desafio existente
  Future<void> updateChallenge(Challenge challenge);
  
  /// Exclui um desafio
  Future<void> deleteChallenge(String id);
  
  /// Participa de um desafio
  Future<void> joinChallenge({required String challengeId, required String userId});
  
  /// Sai de um desafio
  Future<void> leaveChallenge({required String challengeId, required String userId});
  
  /// Convida um usuário para um desafio
  Future<ChallengeInvite> inviteUserToChallenge({
    required String challengeId, 
    required String inviterId, 
    required String inviteeId,
    required String challengeTitle,
    required String inviterName,
  });
  
  /// Obtém convites pendentes para um usuário
  Future<List<ChallengeInvite>> getPendingInvites(String userId);
  
  /// Responde a um convite (aceitar/recusar)
  Future<void> respondToInvite({
    required String inviteId, 
    required InviteStatus status
  });
  
  /// Atualiza o progresso de um usuário em um desafio
  Future<void> updateUserProgress({
    required String challengeId, 
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required int points,
    required double completionPercentage,
  });
  
  /// Obtém o ranking/progresso de um desafio
  Future<List<ChallengeProgress>> getChallengeRanking(String challengeId);
}

/// Implementação do repositório de desafios usando Supabase
class SupabaseChallengeRepository implements ChallengeRepository {
  final SupabaseClient _client;
  
  SupabaseChallengeRepository(this._client);
  
  @override
  Future<List<Challenge>> getChallenges() async {
    try {
      final response = await _client
          .from('challenges')
          .select()
          .order('created_at', ascending: false);
          
      return (response as List<dynamic>)
          .map((data) => Challenge.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar desafios',
        originalError: e,
      );
    }
  }
  
  @override
  Future<Challenge> getChallengeById(String id) async {
    try {
      final response = await _client
          .from('challenges')
          .select()
          .eq('id', id)
          .single();
          
      return Challenge.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is PostgrestException) {
        throw ResourceNotFoundException(
          message: 'Desafio não encontrado',
          originalError: e,
        );
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
          .or('participants.cs.{${userId}},creator_id.eq.${userId}')
          .order('created_at', ascending: false);
          
      return (response as List<dynamic>)
          .map((data) => Challenge.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar desafios do usuário',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<Challenge>> getActiveChallenges() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _client
          .from('challenges')
          .select()
          .gt('end_date', now)
          .order('start_date', ascending: true);
          
      return (response as List<dynamic>)
          .map((data) => Challenge.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar desafios ativos',
        originalError: e,
      );
    }
  }
  
  @override
  Future<Challenge?> getOfficialChallenge() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _client
          .from('challenges')
          .select()
          .eq('is_official', true)
          .gt('end_date', now)
          .order('start_date', ascending: true)
          .limit(1);
          
      if (response.isEmpty) {
        return null;
      }
      
      return Challenge.fromJson(response.first as Map<String, dynamic>);
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar desafio oficial',
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
          
      if (response.isEmpty) {
        return null;
      }
      
      return Challenge.fromJson(response.first as Map<String, dynamic>);
    } catch (e) {
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
          .single();
          
      return Challenge.fromJson(response as Map<String, dynamic>);
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
  Future<void> joinChallenge({required String challengeId, required String userId}) async {
    try {
      // Primeiro, obtém o desafio atual
      final challenge = await getChallengeById(challengeId);
      
      // Verifica se o usuário já está participando
      if (challenge.participants.contains(userId)) {
        return; // Já está participando, não faz nada
      }
      
      // Adiciona o usuário à lista de participantes
      final updatedParticipants = [...challenge.participants, userId];
      
      // Atualiza o desafio
      await _client
          .from('challenges')
          .update({'participants': updatedParticipants})
          .eq('id', challengeId);
    } catch (e) {
      if (e is ResourceNotFoundException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao entrar no desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> leaveChallenge({required String challengeId, required String userId}) async {
    try {
      // Primeiro, obtém o desafio atual
      final challenge = await getChallengeById(challengeId);
      
      // Remove o usuário da lista de participantes
      final updatedParticipants = challenge.participants
          .where((id) => id != userId)
          .toList();
      
      // Atualiza o desafio
      await _client
          .from('challenges')
          .update({'participants': updatedParticipants})
          .eq('id', challengeId);
    } catch (e) {
      if (e is ResourceNotFoundException) {
        rethrow;
      }
      throw DatabaseException(
        message: 'Falha ao sair do desafio',
        originalError: e,
      );
    }
  }
  
  @override
  Future<ChallengeInvite> inviteUserToChallenge({
    required String challengeId,
    required String inviterId,
    required String inviteeId,
    required String challengeTitle,
    required String inviterName,
  }) async {
    try {
      final inviteData = {
        'challenge_id': challengeId,
        'challenge_title': challengeTitle,
        'inviter_id': inviterId,
        'inviter_name': inviterName,
        'invitee_id': inviteeId,
        'status': InviteStatus.pending.index,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final response = await _client
          .from('challenge_invites')
          .insert(inviteData)
          .select()
          .single();
          
      // Atualiza também o desafio para adicionar à lista de convidados
      final challenge = await getChallengeById(challengeId);
      if (!challenge.invitedUsers.contains(inviteeId)) {
        final updatedInvitedUsers = [...challenge.invitedUsers, inviteeId];
        await _client
            .from('challenges')
            .update({'invited_users': updatedInvitedUsers})
            .eq('id', challengeId);
      }
          
      return ChallengeInvite.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao convidar usuário',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<ChallengeInvite>> getPendingInvites(String userId) async {
    try {
      final response = await _client
          .from('challenge_invites')
          .select()
          .eq('invitee_id', userId)
          .eq('status', InviteStatus.pending.index)
          .order('created_at', ascending: false);
          
      return (response as List<dynamic>)
          .map((data) => ChallengeInvite.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar convites pendentes',
        originalError: e,
      );
    }
  }
  
  @override
  Future<void> respondToInvite({
    required String inviteId,
    required InviteStatus status,
  }) async {
    try {
      final updateData = {
        'status': status.index,
        'responded_at': DateTime.now().toIso8601String(),
      };
      
      final invite = await _client
          .from('challenge_invites')
          .update(updateData)
          .eq('id', inviteId)
          .select()
          .single();
          
      final inviteData = invite as Map<String, dynamic>;
      
      // Se o convite foi aceito, adiciona o usuário como participante
      if (status == InviteStatus.accepted) {
        await joinChallenge(
          challengeId: inviteData['challenge_id'],
          userId: inviteData['invitee_id'],
        );
      }
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao responder ao convite',
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
      final existing = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .eq('user_id', userId)
          .maybeSingle();
          
      final progressData = {
        'challenge_id': challengeId,
        'user_id': userId,
        'user_name': userName,
        'user_photo_url': userPhotoUrl,
        'points': points,
        'completion_percentage': completionPercentage,
        'last_updated': DateTime.now().toIso8601String(),
      };
      
      if (existing != null) {
        // Atualiza o registro existente
        await _client
            .from('challenge_progress')
            .update(progressData)
            .eq('id', existing['id']);
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
      final progressList = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .order('points', ascending: false);
          
      // Atualiza a posição de cada participante
      for (int i = 0; i < progressList.length; i++) {
        final progress = progressList[i];
        await _client
            .from('challenge_progress')
            .update({'position': i + 1})
            .eq('id', progress['id']);
      }
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao atualizar rankings',
        originalError: e,
      );
    }
  }
  
  @override
  Future<List<ChallengeProgress>> getChallengeRanking(String challengeId) async {
    try {
      final response = await _client
          .from('challenge_progress')
          .select()
          .eq('challenge_id', challengeId)
          .order('position', ascending: true);
          
      return (response as List<dynamic>)
          .map((data) => ChallengeProgress.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Falha ao buscar ranking do desafio',
        originalError: e,
      );
    }
  }
}

/// Implementação mock do repositório de desafios para desenvolvimento
class MockChallengeRepository implements ChallengeRepository {
  final SupabaseClient _client;
  final List<Challenge> _mockChallenges = [];
  final List<ChallengeInvite> _mockInvites = [];
  final List<ChallengeProgress> _mockProgress = [];
  
  MockChallengeRepository(this._client) {
    _initializeMockData();
  }
  
  void _initializeMockData() {
    final now = DateTime.now();
    
    // Desafios
    _mockChallenges.addAll([
      Challenge(
        id: '1',
        title: 'Desafio Ray 2023',
        description: 'Desafio oficial da Ray Club! Complete 30 dias de treino consecutivos e ganhe recompensas especiais!',
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        reward: 500,
        creatorId: 'admin',
        isOfficial: true,
        participants: ['user1', 'user2'],
        invitedUsers: [],
        imageUrl: 'https://images.unsplash.com/photo-1594737625785-a6cbdabd333c?q=80&w=1000',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      Challenge(
        id: '2',
        title: 'Maratona Fitness',
        description: 'Acumule 100km em corridas durante o mês e ganhe uma camiseta exclusiva.',
        startDate: now,
        endDate: now.add(const Duration(days: 30)),
        reward: 800,
        creatorId: 'user3',
        participants: ['user3'],
        invitedUsers: ['user1', 'user4'],
        imageUrl: 'https://images.unsplash.com/photo-1596357395217-80de13130e92?q=80&w=1000',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      Challenge(
        id: '3',
        title: 'Desafio de Força',
        description: 'Complete 10 sessões de treino de força em 2 semanas.',
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 9)),
        reward: 300,
        creatorId: 'user1',
        participants: ['user1', 'user4', 'user5'],
        invitedUsers: ['user2', 'user6'],
        imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?q=80&w=1000',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Challenge(
        id: '4',
        title: 'Desafio Yoga',
        description: 'Pratique yoga por 15 minutos todos os dias durante 21 dias.',
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 26)),
        reward: 400,
        creatorId: 'user2',
        participants: [],
        invitedUsers: ['user1', 'user3', 'user5'],
        imageUrl: 'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?q=80&w=1000',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
    
    // Convites
    _mockInvites.addAll([
      ChallengeInvite(
        id: '1',
        challengeId: '2',
        challengeTitle: 'Maratona Fitness',
        inviterId: 'user3',
        inviterName: 'João Silva',
        inviteeId: 'user1',
        status: InviteStatus.pending,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      ChallengeInvite(
        id: '2',
        challengeId: '4',
        challengeTitle: 'Desafio Yoga',
        inviterId: 'user2',
        inviterName: 'Maria Souza',
        inviteeId: 'user1',
        status: InviteStatus.pending,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ]);
    
    // Progresso
    _mockProgress.addAll([
      ChallengeProgress(
        id: '1',
        challengeId: '1',
        userId: 'user1',
        userName: 'Ana Martins',
        points: 250,
        position: 1,
        completionPercentage: 0.5,
        lastUpdated: now.subtract(const Duration(hours: 8)),
      ),
      ChallengeProgress(
        id: '2',
        challengeId: '1',
        userId: 'user2',
        userName: 'Pedro Costa',
        points: 180,
        position: 2,
        completionPercentage: 0.35,
        lastUpdated: now.subtract(const Duration(hours: 6)),
      ),
    ]);
  }
  
  @override
  Future<List<Challenge>> getChallenges() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    return [..._mockChallenges];
  }
  
  @override
  Future<Challenge> getChallengeById(String id) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    final challenge = _mockChallenges.firstWhere(
      (challenge) => challenge.id == id,
      orElse: () => throw ResourceNotFoundException(
        message: 'Desafio não encontrado',
      ),
    );
    
    return challenge;
  }
  
  @override
  Future<List<Challenge>> getUserChallenges(String userId) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    return _mockChallenges
        .where((challenge) => 
            challenge.participants.contains(userId) || 
            challenge.creatorId == userId)
        .toList();
  }
  
  @override
  Future<List<Challenge>> getActiveChallenges() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    final now = DateTime.now();
    return _mockChallenges
        .where((challenge) => challenge.endDate.isAfter(now))
        .toList();
  }
  
  @override
  Future<Challenge?> getOfficialChallenge() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    final officialChallenges = _mockChallenges
        .where((challenge) => 
            challenge.isOfficial && challenge.endDate.isAfter(now))
        .toList();
    
    if (officialChallenges.isEmpty) {
      return null;
    }
    
    return officialChallenges.first;
  }
  
  @override
  Future<Challenge?> getMainChallenge() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    final activeChallenges = _mockChallenges
        .where((challenge) => challenge.endDate.isAfter(now))
        .toList();
    
    if (activeChallenges.isEmpty) {
      return null;
    }
    
    // Prioriza desafios oficiais
    final officialChallenges = activeChallenges
        .where((challenge) => challenge.isOfficial)
        .toList();
    
    if (officialChallenges.isNotEmpty) {
      return officialChallenges.first;
    }
    
    return activeChallenges.first;
  }
  
  @override
  Future<Challenge> createChallenge(Challenge challenge) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final newChallenge = challenge.copyWith(
      id: 'challenge_${_mockChallenges.length + 1}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _mockChallenges.add(newChallenge);
    return newChallenge;
  }
  
  @override
  Future<void> updateChallenge(Challenge challenge) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = _mockChallenges.indexWhere((c) => c.id == challenge.id);
    if (index < 0) {
      throw ResourceNotFoundException(
        message: 'Desafio não encontrado',
      );
    }
    
    final updatedChallenge = challenge.copyWith(
      updatedAt: DateTime.now(),
    );
    
    _mockChallenges[index] = updatedChallenge;
  }
  
  @override
  Future<void> deleteChallenge(String id) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = _mockChallenges.indexWhere((c) => c.id == id);
    if (index < 0) {
      throw ResourceNotFoundException(
        message: 'Desafio não encontrado',
      );
    }
    
    _mockChallenges.removeAt(index);
  }
  
  @override
  Future<void> joinChallenge({required String challengeId, required String userId}) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = _mockChallenges.indexWhere((c) => c.id == challengeId);
    if (index < 0) {
      throw ResourceNotFoundException(
        message: 'Desafio não encontrado',
      );
    }
    
    final challenge = _mockChallenges[index];
    
    // Verifica se o usuário já está participando
    if (challenge.participants.contains(userId)) {
      return; // Já está participando, não faz nada
    }
    
    // Adiciona o usuário à lista de participantes
    final updatedParticipants = [...challenge.participants, userId];
    
    // Atualiza o desafio
    _mockChallenges[index] = challenge.copyWith(
      participants: updatedParticipants,
      updatedAt: DateTime.now(),
    );
  }
  
  @override
  Future<void> leaveChallenge({required String challengeId, required String userId}) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = _mockChallenges.indexWhere((c) => c.id == challengeId);
    if (index < 0) {
      throw ResourceNotFoundException(
        message: 'Desafio não encontrado',
      );
    }
    
    final challenge = _mockChallenges[index];
    
    // Remove o usuário da lista de participantes
    final updatedParticipants = challenge.participants
        .where((id) => id != userId)
        .toList();
    
    // Atualiza o desafio
    _mockChallenges[index] = challenge.copyWith(
      participants: updatedParticipants,
      updatedAt: DateTime.now(),
    );
  }
  
  @override
  Future<ChallengeInvite> inviteUserToChallenge({
    required String challengeId,
    required String inviterId,
    required String inviteeId,
    required String challengeTitle,
    required String inviterName,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Verifica se o desafio existe
    final challengeIndex = _mockChallenges.indexWhere((c) => c.id == challengeId);
    if (challengeIndex < 0) {
      throw ResourceNotFoundException(
        message: 'Desafio não encontrado',
      );
    }
    
    // Cria o convite
    final newInvite = ChallengeInvite(
      id: 'invite_${_mockInvites.length + 1}',
      challengeId: challengeId,
      challengeTitle: challengeTitle,
      inviterId: inviterId,
      inviterName: inviterName,
      inviteeId: inviteeId,
      status: InviteStatus.pending,
      createdAt: DateTime.now(),
    );
    
    _mockInvites.add(newInvite);
    
    // Atualiza a lista de convidados do desafio
    final challenge = _mockChallenges[challengeIndex];
    if (!challenge.invitedUsers.contains(inviteeId)) {
      final updatedInvitedUsers = [...challenge.invitedUsers, inviteeId];
      _mockChallenges[challengeIndex] = challenge.copyWith(
        invitedUsers: updatedInvitedUsers,
        updatedAt: DateTime.now(),
      );
    }
    
    return newInvite;
  }
  
  @override
  Future<List<ChallengeInvite>> getPendingInvites(String userId) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    return _mockInvites
        .where((invite) => 
            invite.inviteeId == userId && 
            invite.status == InviteStatus.pending)
        .toList();
  }
  
  @override
  Future<void> respondToInvite({
    required String inviteId,
    required InviteStatus status,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = _mockInvites.indexWhere((invite) => invite.id == inviteId);
    if (index < 0) {
      throw ResourceNotFoundException(
        message: 'Convite não encontrado',
      );
    }
    
    final invite = _mockInvites[index];
    
    // Atualiza o status do convite
    _mockInvites[index] = invite.copyWith(
      status: status,
      respondedAt: DateTime.now(),
    );
    
    // Se o convite foi aceito, adiciona o usuário como participante
    if (status == InviteStatus.accepted) {
      await joinChallenge(
        challengeId: invite.challengeId,
        userId: invite.inviteeId,
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
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Verifica se já existe um registro de progresso
    final index = _mockProgress.indexWhere(
      (p) => p.challengeId == challengeId && p.userId == userId);
    
    if (index >= 0) {
      // Atualiza o registro existente
      _mockProgress[index] = _mockProgress[index].copyWith(
        points: points,
        completionPercentage: completionPercentage,
        lastUpdated: DateTime.now(),
      );
    } else {
      // Cria um novo registro
      _mockProgress.add(ChallengeProgress(
        id: 'progress_${_mockProgress.length + 1}',
        challengeId: challengeId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        points: points,
        position: 0, // Será atualizado abaixo
        completionPercentage: completionPercentage,
        lastUpdated: DateTime.now(),
      ));
    }
    
    // Atualiza as posições
    await _updateRankings(challengeId);
  }
  
  // Método auxiliar para atualizar as posições no ranking
  Future<void> _updateRankings(String challengeId) async {
    final progressForChallenge = _mockProgress
        .where((p) => p.challengeId == challengeId)
        .toList()
        ..sort((a, b) => b.points.compareTo(a.points));
    
    for (int i = 0; i < progressForChallenge.length; i++) {
      final progress = progressForChallenge[i];
      final index = _mockProgress.indexWhere((p) => p.id == progress.id);
      if (index >= 0) {
        _mockProgress[index] = _mockProgress[index].copyWith(
          position: i + 1,
        );
      }
    }
  }
  
  @override
  Future<List<ChallengeProgress>> getChallengeRanking(String challengeId) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));
    
    return _mockProgress
        .where((p) => p.challengeId == challengeId)
        .toList()
        ..sort((a, b) => a.position.compareTo(b.position));
  }
} 