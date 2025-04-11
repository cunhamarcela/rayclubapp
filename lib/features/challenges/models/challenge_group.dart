// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Importação do arquivo challenge.dart para usar o enum InviteStatus
import 'challenge.dart';

part 'challenge_group.freezed.dart';
part 'challenge_group.g.dart';

/// Representa um grupo dentro do desafio principal.
/// Os usuários podem criar grupos para visualizar rankings específicos
/// de participantes convidados.
@freezed
class ChallengeGroup with _$ChallengeGroup {
  const factory ChallengeGroup({
    /// ID único do grupo
    required String id,
    
    /// ID do desafio principal ao qual este grupo pertence
    required String challengeId,
    
    /// ID do usuário que criou o grupo
    required String creatorId,
    
    /// Nome do grupo
    required String name,
    
    /// Descrição opcional do grupo
    String? description,
    
    /// Lista de IDs dos membros do grupo (incluindo o criador)
    @Default([]) List<String> memberIds,
    
    /// Lista de IDs dos usuários convidados pendentes
    @Default([]) List<String> pendingInviteIds,
    
    /// Data de criação do grupo
    required DateTime createdAt,
    
    /// Data da última atualização do grupo
    DateTime? updatedAt,
  }) = _ChallengeGroup;

  /// Cria um ChallengeGroup a partir de um mapa JSON
  factory ChallengeGroup.fromJson(Map<String, dynamic> json) => 
      _$ChallengeGroupFromJson(json);
  
  const ChallengeGroup._();
  
  /// Retorna o número total de membros no grupo
  int get memberCount => memberIds.length;
  
  /// Verifica se um usuário é membro do grupo
  bool isMember(String userId) => memberIds.contains(userId);
  
  /// Verifica se um usuário está convidado, mas ainda não aceitou
  bool isPendingInvite(String userId) => pendingInviteIds.contains(userId);
}

/// Modelo para convites de desafios em grupo
@freezed
class ChallengeGroupInvite with _$ChallengeGroupInvite {
  const factory ChallengeGroupInvite({
    /// ID único do convite
    required String id,
    
    /// ID do grupo para o qual o usuário está sendo convidado
    required String groupId,
    
    /// Nome do grupo (para exibição)
    required String groupName,
    
    /// ID do usuário que está convidando
    required String inviterId,
    
    /// Nome do usuário que está convidando (para exibição)
    required String inviterName,
    
    /// ID do usuário que está sendo convidado
    required String inviteeId,
    
    /// Status do convite (pendente, aceito, recusado)
    @Default(InviteStatus.pending) InviteStatus status,
    
    /// Data de criação do convite
    required DateTime createdAt,
    
    /// Data de resposta do convite (quando aceito ou recusado)
    DateTime? respondedAt,
  }) = _ChallengeGroupInvite;

  /// Cria um ChallengeGroupInvite a partir de um mapa JSON
  factory ChallengeGroupInvite.fromJson(Map<String, dynamic> json) => 
      _$ChallengeGroupInviteFromJson(json);
} 