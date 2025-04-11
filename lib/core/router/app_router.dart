// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/intro/screens/intro_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/challenges/widgets/user_selection_list.dart';
import '../../features/benefits/screens/benefit_admin_screen.dart';
import '../../features/benefits/screens/benefit_detail_screen.dart';
import '../../features/benefits/screens/benefit_form_screen.dart';
import '../../features/benefits/screens/benefits_list_screen.dart';
import '../../features/benefits/screens/redeemed_benefit_detail_screen.dart';
import '../../features/benefits/screens/redeemed_benefits_screen.dart';
import '../../features/challenges/screens/challenge_detail_screen.dart';
import '../../features/challenges/screens/challenge_form_screen.dart';
import '../../features/challenges/screens/challenge_group_detail_screen.dart';
import '../../features/challenges/screens/challenge_group_invites_screen.dart';
import '../../features/challenges/screens/challenge_groups_screen.dart';
import '../../features/challenges/screens/challenge_invites_screen.dart';
import '../../features/challenges/screens/challenge_ranking_screen.dart';
import '../../features/challenges/screens/challenges_admin_screen.dart';
import '../../features/challenges/screens/challenges_list_screen.dart';
import '../../features/challenges/screens/create_challenge_screen.dart';
import '../../features/challenges/screens/invite_users_screen.dart';
import '../../features/challenges/screens/realtime_challenge_detail_screen.dart';
import '../../features/goals/models/user_goal_model.dart';
import '../../features/help/screens/help_screen.dart';
import '../../features/home/screens/featured_content_detail_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/nutrition/screens/meal_detail_screen.dart';
import '../../features/nutrition/screens/nutrition_screen.dart';
import '../../features/nutrition/screens/recipe_detail_screen.dart';
import '../../features/progress/screens/progress_plan_screen.dart';
import '../../features/profile/screens/consent_management_screen.dart';
import '../../features/profile/screens/goal_form_screen.dart';
import '../../features/profile/screens/notification_settings_screen.dart';
import '../../features/profile/screens/notification_settings_screen_refactored.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/profile/screens/profile_edit_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/terms_of_use_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/workout/screens/workout_categories_screen.dart';
import '../../features/workout/screens/workout_detail_screen.dart';
import '../../features/workout/screens/workout_history_screen.dart';
import '../../features/workout/screens/workout_list_screen.dart';
import 'admin_guard.dart';
import 'auth_guard.dart';
import 'layered_auth_guard.dart';
import 'critical_route_guard.dart';

part 'app_router.gr.dart';

/// Provider para o router da aplicação
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

/// Rotas definidas como classes tipadas para melhor segurança de tipos
@immutable
abstract class AppRoutes {
  // Rotas públicas
  static const intro = '/intro';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  
  // Rotas protegidas principais
  static const home = '/';
  static const workout = '/workouts';
  static String workoutDetail(String id) => '/workouts/$id';
  static const workoutHistory = '/workouts/history';
  static const nutrition = '/nutrition';
  static String recipeDetail(String id) => '/nutrition/recipe/$id';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const privacyPolicy = '/privacy-policy';
  static const consentManagement = '/consent-management';
  static const goalForm = '/profile/goal-form';
  static const termsOfUse = '/terms-of-use';
  static const notificationSettings = '/notification-settings';
  static const settings = '/settings';
  static const help = '/help';
  
  // Rotas de conteúdo
  static String featuredContent(String id) => '/featured-content/$id';
  
  // Rotas de benefícios
  static const benefits = '/benefits';
  static const benefitDetail = '/benefits/detail';
  static const redeemedBenefits = '/benefits/redeemed';
  static const redeemedBenefitDetail = '/benefits/redeemed/detail';
  
  // Rotas de desafios
  static const challenges = '/challenges';
  static String challengeDetail(String challengeId) => '/challenges/$challengeId';
  static String realtimeChallengeDetail(String challengeId) => '/challenges/realtime/$challengeId';
  static String challengeForm({String? id}) => id != null 
      ? '/challenges/form/$id' 
      : '/challenges/form';
  static String challengeRanking(String challengeId) => '/challenges/ranking/$challengeId';
  static String challengeInvites(String userId) => '/challenges/invites/$userId';
  
  // Rotas de grupos de desafios
  static const challengeGroups = '/challenges/groups';
  static String challengeGroupDetail(String groupId) => '/challenges/groups/$groupId';
  static const challengeGroupInvites = '/challenges/groups/invites';
  
  // Rotas de progresso
  static const progressPlan = '/progress/plan';
  static String progressDay(int day) => '/progress/day/$day';
  
  // Rotas administrativas
  static const adminBenefits = '/admin/benefits';
  static const adminBenefitForm = '/admin/benefits/form';
  static const adminChallenges = '/admin/challenges';
}

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final ProviderRef _ref;

  AppRouter(this._ref);

  @override
  List<AutoRoute> get routes => [
        // Rotas públicas (não protegidas)
        AutoRoute(
          path: AppRoutes.intro,
          page: IntroRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: AppRoutes.login,
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: AppRoutes.signup,
          page: SignupRoute.page,
        ),
        AutoRoute(
          path: AppRoutes.forgotPassword,
          page: ForgotPasswordRoute.page,
        ),
        AutoRoute(
          path: AppRoutes.resetPassword,
          page: ResetPasswordRoute.page,
        ),
        
        // Rotas protegidas (requerem autenticação com verificação em camadas)
        AutoRoute(
          path: AppRoutes.home,
          page: HomeRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.workout,
          page: WorkoutCategoriesRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/workouts/:id',
          page: WorkoutDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.workoutHistory,
          page: WorkoutHistoryRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.nutrition,
          page: NutritionRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/nutrition/recipe/:id',
          page: RecipeDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.profile,
          page: ProfileRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.profileEdit,
          page: ProfileEditRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.privacyPolicy,
          page: PrivacyPolicyRoute.page,
        ),
        AutoRoute(
          path: AppRoutes.consentManagement,
          page: ConsentManagementRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.termsOfUse,
          page: TermsOfUseRoute.page,
        ),
        AutoRoute(
          path: AppRoutes.notificationSettings,
          page: NotificationSettingsRouteRefactored.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.settings,
          page: SettingsRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.help,
          page: HelpRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.goalForm,
          page: GoalFormRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/featured-content/:id',
          page: FeaturedContentDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        
        // Rotas de Benefícios (protegidas)
        AutoRoute(
          path: AppRoutes.benefits,
          page: BenefitsListRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.benefitDetail,
          page: BenefitDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.redeemedBenefits,
          page: RedeemedBenefitsRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.redeemedBenefitDetail,
          page: RedeemedBenefitDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        
        // Rotas de Desafios (protegidas)
        AutoRoute(
          path: AppRoutes.challenges,
          page: ChallengesListRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/realtime/:challengeId',
          page: RealtimeChallengeDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/form/:id',
          page: ChallengeFormRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/form',
          page: CreateChallengeRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/ranking/:challengeId',
          page: ChallengeRankingRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/invites/:userId',
          page: ChallengeInvitesRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/:challengeId',
          page: ChallengeDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        
        // Rotas de Progresso (protegidas)
        AutoRoute(
          path: AppRoutes.progressPlan,
          page: ProgressPlanRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/progress/day/:day',
          page: ProgressPlanRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        
        // Rotas de Benefícios para Administradores (protegidas por AdminGuard)
        AutoRoute(
          path: AppRoutes.adminBenefits,
          page: BenefitAdminRoute.page,
          guards: [LayeredAuthGuard(_ref), AdminGuard(_ref)],
        ),
        
        AutoRoute(
          path: AppRoutes.adminBenefitForm,
          page: BenefitFormRoute.page, 
          guards: [LayeredAuthGuard(_ref), AdminGuard(_ref)],
        ),
        
        // Rotas de Desafios para Administradores (protegidas por AdminGuard)
        AutoRoute(
          path: AppRoutes.adminChallenges,
          page: ChallengesAdminRoute.page,
          guards: [LayeredAuthGuard(_ref), AdminGuard(_ref)],
        ),
        
        // Novas rotas para grupos de desafios
        AutoRoute(
          path: AppRoutes.challengeGroups,
          page: ChallengeGroupsRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/groups/:groupId',
          page: ChallengeGroupDetailRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
        AutoRoute(
          path: AppRoutes.challengeGroupInvites,
          page: ChallengeGroupInvitesRoute.page,
          guards: [LayeredAuthGuard(_ref)],
        ),
      ];
      
  @override
  bool get rebuildStackOnDeepLink => true;
}

/// Helper class para navegação com rotas tipadas
class AppNavigator {
  /// Navega para uma rota pelo seu nome
  static void navigateTo(BuildContext context, String path) {
    context.router.navigateNamed(path);
  }
  
  /// Navega para home
  static void navigateToHome(BuildContext context) {
    context.router.navigateNamed(AppRoutes.home);
  }
  
  /// Navega para login
  static void navigateToLogin(BuildContext context) {
    context.router.navigateNamed(AppRoutes.login);
  }
  
  /// Navega para edição de perfil
  static void navigateToProfileEdit(BuildContext context) {
    context.router.navigateNamed(AppRoutes.profileEdit);
  }
  
  /// Navega para formulário de metas
  static Future<bool?> navigateToGoalForm(BuildContext context, {UserGoal? existingGoal}) {
    return context.router.push(GoalFormRoute(existingGoal: existingGoal));
  }
  
  /// Navega para política de privacidade
  static void navigateToPrivacyPolicy(BuildContext context) {
    context.router.navigateNamed(AppRoutes.privacyPolicy);
  }
  
  /// Navega para gerenciamento de consentimentos
  static void navigateToConsentManagement(BuildContext context) {
    context.router.navigateNamed(AppRoutes.consentManagement);
  }
  
  /// Navega para termos de uso
  static void navigateToTermsOfUse(BuildContext context) {
    context.router.navigateNamed(AppRoutes.termsOfUse);
  }
  
  /// Navega para configurações de notificações
  static void navigateToNotificationSettings(BuildContext context) {
    context.router.navigateNamed(AppRoutes.notificationSettings);
  }
  
  /// Navega para configurações
  static void navigateToSettings(BuildContext context) {
    context.router.navigateNamed(AppRoutes.settings);
  }
  
  /// Navega para tela de ajuda
  static void navigateToHelp(BuildContext context) {
    context.router.navigateNamed(AppRoutes.help);
  }
  
  /// Navega para tela de benefícios
  static void navigateToBenefits(BuildContext context) {
    context.router.navigateNamed(AppRoutes.benefits);
  }
  
  /// Navega para tela de desafios
  static void navigateToChallenges(BuildContext context) {
    context.router.navigateNamed(AppRoutes.challenges);
  }
  
  /// Navega para detalhe de desafio
  static void navigateToChallengeDetail(BuildContext context, String challengeId) {
    context.router.navigateNamed(AppRoutes.challengeDetail(challengeId));
  }
  
  /// Navega para tela de criar/editar desafio
  static void navigateToChallengeForm(BuildContext context, {String? id}) {
    context.router.navigateNamed(AppRoutes.challengeForm(id: id));
  }
  
  /// Navega para tela de ranking do desafio
  static void navigateToChallengeRanking(BuildContext context, String challengeId) {
    context.router.navigateNamed(AppRoutes.challengeRanking(challengeId));
  }
  
  /// Navega para tela de convites de desafios
  static void navigateToChallengeInvites(BuildContext context, String userId) {
    context.router.navigateNamed(AppRoutes.challengeInvites(userId));
  }
  
  /// Navega para detalhes de conteúdo em destaque
  static void navigateToFeaturedContent(BuildContext context, String id) {
    context.router.navigateNamed(AppRoutes.featuredContent(id));
  }
  
  /// Navega para o plano de progresso
  static void navigateToProgressPlan(BuildContext context) {
    context.router.navigateNamed(AppRoutes.progressPlan);
  }
  
  /// Navega para o detalhe do dia específico no progresso
  static void navigateToProgressDay(BuildContext context, int day) {
    context.router.navigateNamed(AppRoutes.progressDay(day));
  }
  
  /// Navega para o histórico de treinos
  static void navigateToWorkoutHistory(BuildContext context) {
    context.router.navigateNamed(AppRoutes.workoutHistory);
  }
  
  /// Navega para uma rota com push (permite voltar)
  static void pushTo(BuildContext context, String path) {
    context.router.pushNamed(path);
  }
  
  /// Troca a rota atual por uma nova
  static void replaceTo(BuildContext context, String path) {
    context.router.replaceNamed(path);
  }
  
  /// Volta para a rota anterior
  static void pop(BuildContext context) {
    context.router.maybePop();
  }
  
  /// Verifica se pode navegar de volta
  static bool canPop(BuildContext context) {
    return context.router.canPop();
  }
  
  /// Reseta a pilha de navegação e navega para uma rota
  static void clearStackAndNavigate(BuildContext context, String path) {
    context.router.popUntilRoot();
    context.router.pushNamed(path);
  }
  
  /// Navega para área administrativa de benefícios (apenas admin)
  static void navigateToAdminBenefits(BuildContext context) {
    context.router.navigateNamed(AppRoutes.adminBenefits);
  }
  
  /// Navega para formulário de benefícios (apenas admin)
  static void navigateToAdminBenefitForm(BuildContext context) {
    context.router.navigateNamed(AppRoutes.adminBenefitForm);
  }
  
  /// Navega para área administrativa de desafios (apenas admin)
  static void navigateToAdminChallenges(BuildContext context) {
    context.router.navigateNamed(AppRoutes.adminChallenges);
  }
  
  /// Navega para detalhes de uma receita
  static void navigateToRecipeDetail(BuildContext context, String recipeId, Map<String, dynamic> recipe) {
    context.router.push(RecipeDetailRoute(recipeId: recipeId, recipe: recipe));
  }
}
