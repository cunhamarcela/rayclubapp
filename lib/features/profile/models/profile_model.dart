// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Modelo para armazenar dados do perfil do usuário
@freezed
class Profile with _$Profile {
  const factory Profile({
    /// ID do usuário
    required String id,
    
    /// Nome do usuário
    String? name,
    
    /// E-mail do usuário
    String? email,
    
    /// URL da foto de perfil
    String? photoUrl,
    
    /// Número de treinos completados
    @Default(0) int completedWorkouts,
    
    /// Número de dias em sequência de treino
    @Default(0) int streak,
    
    /// Pontos acumulados pelo usuário
    @Default(0) int points,
    
    /// Data de criação do perfil
    DateTime? createdAt,
    
    /// Data da última atualização do perfil
    DateTime? updatedAt,
    
    /// Biografia ou descrição do usuário
    String? bio,
    
    /// Objetivos de fitness do usuário (ex: "Perder peso", "Ganhar massa muscular")
    @Default([]) List<String> goals,
    
    /// IDs dos treinos favoritos do usuário
    @Default([]) List<String> favoriteWorkoutIds,
    
    /// Número de telefone do usuário
    String? phone,
    
    /// Gênero do usuário
    String? gender,
    
    /// Data de nascimento do usuário
    DateTime? birthDate,
    
    /// Instagram do usuário
    String? instagram,
  }) = _Profile;
  
  /// Cria uma instância de Profile a partir de JSON
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
} 
