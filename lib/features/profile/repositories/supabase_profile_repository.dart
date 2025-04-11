// Flutter imports:
import 'package:flutter/foundation.dart';
import 'dart:io';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException, StorageException;
import 'package:path/path.dart' as path;

// Project imports:
import '../../../core/errors/app_exception.dart';
import '../models/profile_model.dart';
import 'profile_repository.dart';

/// Implementação do repositório de perfil usando Supabase
class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient _client;
  
  /// Nome da tabela de perfis
  static const String _profilesTable = 'profiles';
  
  /// Nome do bucket para imagens de perfil
  static const String _profileImagesBucket = 'profile_images';
  
  /// Construtor
  SupabaseProfileRepository(this._client);
  
  @override
  Future<Profile?> getCurrentUserProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;
      
      return await getProfileById(userId);
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Erro ao obter perfil do usuário atual');
      return null;
    }
  }
  
  @override
  Future<Profile?> getProfileById(String userId) async {
    try {
      final response = await _client
          .from(_profilesTable)
          .select()
          .eq('id', userId)
          .single();
      
      if (response == null) return null;
      
      return Profile.fromJson(response);
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Erro ao obter perfil por ID');
      return null;
    }
  }
  
  @override
  Future<List<Profile>> getAllProfiles() async {
    try {
      final response = await _client
          .from(_profilesTable)
          .select();
      
      return response.map<Profile>((json) => Profile.fromJson(json)).toList();
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Erro ao obter todos os perfis');
      return [];
    }
  }
  
  @override
  Future<Profile> updateProfile(Profile profile) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AppAuthException(message: 'Usuário não autenticado');
      }
      
      if (userId != profile.id) {
        throw AppAuthException(message: 'Não é possível atualizar perfil de outro usuário');
      }
      
      final updateData = {
        'name': profile.name,
        'goals': profile.goals,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      await _client
          .from(_profilesTable)
          .update(updateData)
          .eq('id', userId);
      
      // Buscar o perfil atualizado
      final updatedProfile = await getProfileById(userId);
      if (updatedProfile == null) {
        throw StorageException(message: 'Falha ao recuperar perfil atualizado');
      }
      
      return updatedProfile;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao atualizar perfil');
    }
  }
  
  @override
  Future<String> updateProfilePhoto(String userId, String filePath) async {
    try {
      final authUserId = _client.auth.currentUser?.id;
      if (authUserId == null) {
        throw AppAuthException(message: 'Usuário não autenticado');
      }
      
      if (authUserId != userId) {
        throw AppAuthException(message: 'Não é possível atualizar foto de outro usuário');
      }
      
      // Nome único para o arquivo (usando timestamp)
      final fileExt = path.extension(filePath);
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExt';
      
      // Upload da imagem
      final file = File(filePath);
      await _client.storage
          .from(_profileImagesBucket)
          .upload(fileName, file);
          
      // Obter URL pública da imagem
      final imageUrl = _client.storage
          .from(_profileImagesBucket)
          .getPublicUrl(fileName);
          
      // Atualizar URL da imagem no perfil
      await _client
          .from(_profilesTable)
          .update({'photo_url': imageUrl})
          .eq('id', userId);
          
      return imageUrl;
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao atualizar foto de perfil');
    }
  }
  
  @override
  Future<Profile> addWorkoutToFavorites(String userId, String workoutId) async {
    try {
      // Obter perfil atual para verificar se já tem esse treino nos favoritos
      final profile = await getProfileById(userId);
      if (profile == null) {
        throw StorageException(message: 'Perfil não encontrado');
      }
      
      // Verificar se o treino já está nos favoritos
      if (profile.favoriteWorkoutIds.contains(workoutId)) {
        return profile; // Já está nos favoritos, retorna perfil sem alterações
      }
      
      // Adicionar treino aos favoritos
      final updatedFavorites = List<String>.from(profile.favoriteWorkoutIds)..add(workoutId);
      
      await _client
          .from(_profilesTable)
          .update({
            'favorite_workout_ids': updatedFavorites,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
          
      return profile.copyWith(favoriteWorkoutIds: updatedFavorites);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao adicionar treino aos favoritos');
    }
  }
  
  @override
  Future<Profile> removeWorkoutFromFavorites(String userId, String workoutId) async {
    try {
      // Obter perfil atual para verificar se tem esse treino nos favoritos
      final profile = await getProfileById(userId);
      if (profile == null) {
        throw StorageException(message: 'Perfil não encontrado');
      }
      
      // Verificar se o treino está nos favoritos
      if (!profile.favoriteWorkoutIds.contains(workoutId)) {
        return profile; // Não está nos favoritos, retorna perfil sem alterações
      }
      
      // Remover treino dos favoritos
      final updatedFavorites = List<String>.from(profile.favoriteWorkoutIds)..remove(workoutId);
      
      await _client
          .from(_profilesTable)
          .update({
            'favorite_workout_ids': updatedFavorites,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
          
      return profile.copyWith(favoriteWorkoutIds: updatedFavorites);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao remover treino dos favoritos');
    }
  }
  
  @override
  Future<Profile> incrementCompletedWorkouts(String userId) async {
    try {
      // Obter perfil atual
      final profile = await getProfileById(userId);
      if (profile == null) {
        throw StorageException(message: 'Perfil não encontrado');
      }
      
      // Incrementar contador de treinos
      final completedWorkouts = profile.completedWorkouts + 1;
      
      await _client
          .from(_profilesTable)
          .update({
            'completed_workouts': completedWorkouts,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
          
      return profile.copyWith(completedWorkouts: completedWorkouts);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao incrementar treinos completados');
    }
  }
  
  @override
  Future<Profile> updateStreak(String userId, int streak) async {
    try {
      // Obter perfil atual
      final profile = await getProfileById(userId);
      if (profile == null) {
        throw StorageException(message: 'Perfil não encontrado');
      }
      
      await _client
          .from(_profilesTable)
          .update({
            'streak': streak,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
          
      return profile.copyWith(streak: streak);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao atualizar streak');
    }
  }
  
  @override
  Future<Profile> addPoints(String userId, int points) async {
    try {
      // Obter perfil atual
      final profile = await getProfileById(userId);
      if (profile == null) {
        throw StorageException(message: 'Perfil não encontrado');
      }
      
      // Adicionar pontos
      final totalPoints = profile.points + points;
      
      await _client
          .from(_profilesTable)
          .update({
            'points': totalPoints,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
          
      return profile.copyWith(points: totalPoints);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao adicionar pontos');
    }
  }
  
  @override
  Future<void> updateEmail(String userId, String email) async {
    try {
      final authUserId = _client.auth.currentUser?.id;
      if (authUserId == null) {
        throw AppAuthException(message: 'Usuário não autenticado');
      }
      
      if (authUserId != userId) {
        throw AppAuthException(message: 'Não é possível atualizar email de outro usuário');
      }
      
      // Atualizar email no Supabase Auth
      await _client.auth.updateUser(
        UserAttributes(
          email: email,
        ),
      );
      
      // Atualizar email na tabela de perfis
      await _client
          .from(_profilesTable)
          .update({
            'email': email,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao atualizar email');
    }
  }
  
  @override
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e, stackTrace) {
      throw _handleError(e, stackTrace, 'Erro ao enviar link de redefinição de senha');
    }
  }
  
  /// Trata erros e lança exceções apropriadas
  Exception _handleError(Object error, StackTrace stackTrace, String defaultMessage) {
    if (kDebugMode) {
      print('Error in SupabaseProfileRepository: $error');
      print(stackTrace);
    }
    
    if (error is PostgrestException) {
      return StorageException(
        message: error.message ?? defaultMessage,
        code: error.code,
      );
    }
    
    if (error is AppAuthException) {
      return error;
    }
    
    if (error is StorageException) {
      return error;
    }
    
    return AppException(
      message: defaultMessage,
      originalError: error,
      stackTrace: stackTrace,
    );
  }
} 