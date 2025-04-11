import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/challenges/models/challenge.dart';
import '../features/challenges/repositories/challenge_repository.dart';
import '../features/auth/repositories/auth_repository.dart';
import '../core/errors/app_exception.dart';

/// Provider para o serviço de integração entre treinos e desafios
final workoutChallengeServiceProvider = Provider<WorkoutChallengeService>((ref) {
  final challengeRepository = ref.watch(challengeRepositoryProvider);
  final authRepository = ref.watch(Provider<IAuthRepository>((ref) {
    final supabaseClient = Supabase.instance.client;
    return AuthRepository(supabaseClient);
  }));
  return WorkoutChallengeService(challengeRepository, authRepository);
});

/// Serviço responsável por processar a conclusão de treinos e atualizar desafios
class WorkoutChallengeService {
  final ChallengeRepository _challengeRepository;
  final IAuthRepository _authRepository;
  
  const WorkoutChallengeService(this._challengeRepository, this._authRepository);
  
  /// Processa a conclusão de um treino e atualiza o progresso nos desafios ativos
  Future<void> processWorkoutCompletion(String userId, DateTime workoutDate) async {
    try {
      // Buscar desafios ativos do usuário
      final userChallenges = await _challengeRepository.getUserActiveChallenges(userId);
      
      for (final challenge in userChallenges) {
        // Verificar se é o desafio oficial da Ray
        if (challenge.isOfficial) {
          // Para o desafio da Ray, cada check-in diário vale pontos
          await _processRayChallengeCheckIn(userId, challenge.id, workoutDate);
        } else {
          // Para desafios privados, usar regras do desafio
          await _processPrivateChallengeProgress(userId, challenge, workoutDate);
        }
      }
    } catch (e) {
      debugPrint('Erro ao processar conclusão de treino: $e');
      throw ChallengeProcessingException(
        message: 'Falha ao atualizar progresso nos desafios',
        originalError: e,
      );
    }
  }
  
  /// Processa check-in para o desafio oficial da Ray
  Future<void> _processRayChallengeCheckIn(String userId, String challengeId, DateTime workoutDate) async {
    try {
      // Verificar se já houve check-in neste dia para este desafio
      final hasCheckedInToday = await _challengeRepository.hasCheckedInOnDate(
        userId, challengeId, workoutDate
      );
      
      if (!hasCheckedInToday) {
        // Para fins de teste, podemos fornecer informações padrão se o usuário for nulo
        String userName = 'Usuário';
        String? photoUrl;

        // Buscar informações do usuário
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          userName = user.userMetadata?['name'] as String? ?? 'Usuário';
          photoUrl = user.userMetadata?['avatar_url'] as String?;
        }
        
        final challenge = await _challengeRepository.getChallengeById(challengeId);
        final requirements = challenge.requirements ?? [];
        
        // Converter requirements para mapa se for uma lista
        final Map<String, dynamic> requirementsMap = requirements is List 
            ? {} 
            : requirements as Map<String, dynamic>;
        
        // Obter pontos diários das regras do desafio ou usar valor padrão
        final int dailyPoints = requirementsMap['daily_points'] as int? ?? 10;
        
        // Registrar check-in e adicionar pontos
        await _challengeRepository.recordChallengeCheckIn(
          userId, 
          challengeId, 
          workoutDate, 
          dailyPoints,
          userName,
          photoUrl
        );
        
        // Pontos extras para sequências de dias consecutivos
        await _processConsecutiveDaysBonus(userId, challengeId, userName, photoUrl);
      }
    } catch (e) {
      debugPrint('Erro ao processar check-in para desafio da Ray: $e');
      // Não repassar a exceção para não interromper o fluxo principal
    }
  }
  
  /// Processa bônus para dias consecutivos
  Future<void> _processConsecutiveDaysBonus(
    String userId, 
    String challengeId, 
    String userName,
    String? userPhotoUrl
  ) async {
    try {
      final consecutiveDays = await _challengeRepository.getConsecutiveDaysCount(userId, challengeId);
      final challenge = await _challengeRepository.getChallengeById(challengeId);
      final requirements = challenge.requirements ?? [];
      
      // Converter requirements para mapa se for uma lista
      final Map<String, dynamic> requirementsMap = requirements is List 
          ? {} 
          : requirements as Map<String, dynamic>;
      
      // Obter valor do bônus semanal das regras do desafio ou usar valor padrão
      final int weeklyStreakBonus = requirementsMap['streak_bonus'] as int? ?? 50;
      
      // Bônus para marcos de dias consecutivos
      if (consecutiveDays % 7 == 0) { // A cada 7 dias consecutivos
        await _challengeRepository.addBonusPoints(
          userId, 
          challengeId, 
          weeklyStreakBonus,
          'Bônus de sequência: $consecutiveDays dias consecutivos',
          userName,
          userPhotoUrl
        );
      }
    } catch (e) {
      debugPrint('Erro ao processar bônus de dias consecutivos: $e');
      // Não repassar a exceção para não interromper o fluxo principal
    }
  }
  
  /// Processa progresso para desafios privados personalizados
  Future<void> _processPrivateChallengeProgress(
    String userId, 
    Challenge challenge, 
    DateTime workoutDate
  ) async {
    try {
      // Verificar se já houve check-in neste dia para este desafio
      final hasCheckedInToday = await _challengeRepository.hasCheckedInOnDate(
        userId, challenge.id, workoutDate
      );
      
      if (!hasCheckedInToday) {
        // Para fins de teste, podemos fornecer informações padrão se o usuário for nulo
        String userName = 'Usuário';
        String? photoUrl;

        // Buscar informações do usuário
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          userName = user.userMetadata?['name'] as String? ?? 'Usuário';
          photoUrl = user.userMetadata?['avatar_url'] as String?;
        }
        
        // Pontos base para check-in em desafio privado
        const basePoints = 5;
        
        // Registrar check-in
        await _challengeRepository.recordChallengeCheckIn(
          userId, 
          challenge.id, 
          workoutDate, 
          basePoints,
          userName,
          photoUrl
        );
      }
    } catch (e) {
      debugPrint('Erro ao processar progresso para desafio privado: $e');
      // Não repassar a exceção para não interromper o fluxo principal
    }
  }
}

/// Exceção específica para processamento de desafios
class ChallengeProcessingException extends AppException {
  const ChallengeProcessingException({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);
}

/// Extensão para facilitar formatação de data
extension DateTimeHelpers on DateTime {
  String toIso8601DateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
} 