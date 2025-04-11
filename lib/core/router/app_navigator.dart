// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ray_club_app/core/router/app_router.dart';
import 'package:ray_club_app/features/goals/models/user_goal_model.dart';

/// Utilitário para navegação entre telas
class AppNavigator {
  /// Navega para a tela de detalhes de um desafio
  static void navigateToChallengeDetail(BuildContext context, String challengeId) {
    context.router.pushNamed('/challenges/$challengeId');
  }
  
  /// Navega para o formulário de criação/edição de desafio
  static void navigateToChallengeForm(BuildContext context, {String? id}) {
    final route = id != null ? '/challenges/form/$id' : '/challenges/form';
    context.router.pushNamed(route);
  }

  /// Navega para formulário de metas
  static Future<bool?> navigateToGoalForm(BuildContext context, {UserGoal? existingGoal}) {
    return context.router.push(GoalFormRoute(existingGoal: existingGoal));
  }
  
  /// Navega para a lista de grupos do usuário
  static void navigateToChallengeGroups(BuildContext context) {
    context.router.pushNamed(AppRoutes.challengeGroups);
  }
  
  /// Navega para os detalhes de um grupo específico
  static void navigateToChallengeGroupDetail(BuildContext context, String groupId) {
    context.router.pushNamed('/challenges/groups/$groupId');
  }
  
  /// Navega para a tela de convites de grupos pendentes
  static void navigateToChallengeGroupInvites(BuildContext context) {
    context.router.pushNamed(AppRoutes.challengeGroupInvites);
  }
  
  /// Navega para a tela de ranking de um desafio
  static void navigateToChallengeRanking(BuildContext context, String challengeId) {
    context.router.pushNamed('/challenges/ranking/$challengeId');
  }
} 