import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/router/auth_guard.dart';
import 'package:ray_club_app/features/auth/screens/forgot_password_screen.dart';
import 'package:ray_club_app/features/auth/screens/login_screen.dart';
import 'package:ray_club_app/features/auth/screens/reset_password_screen.dart';
import 'package:ray_club_app/features/auth/screens/signup_screen.dart';
import 'package:ray_club_app/features/benefits/screens/benefit_detail_screen.dart';
import 'package:ray_club_app/features/benefits/screens/benefits_list_screen.dart';
import 'package:ray_club_app/features/benefits/screens/redeemed_benefit_detail_screen.dart';
import 'package:ray_club_app/features/benefits/screens/redeemed_benefits_screen.dart';
import 'package:ray_club_app/features/challenges/screens/challenge_detail_screen.dart';
import 'package:ray_club_app/features/challenges/screens/challenge_form_screen.dart';
import 'package:ray_club_app/features/challenges/screens/challenges_list_screen.dart';
import 'package:ray_club_app/features/home/screens/featured_content_detail_screen.dart';
import 'package:ray_club_app/features/home/screens/home_screen.dart';
import 'package:ray_club_app/features/intro/screens/intro_screen.dart';
import 'package:ray_club_app/features/nutrition/screens/nutrition_screen.dart';
import 'package:ray_club_app/features/profile/screens/profile_screen.dart';
import 'package:ray_club_app/features/workout/screens/workout_list_screen.dart';

part 'app_router.gr.dart';

/// Provider para o router da aplicação
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref);
});

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final ProviderRef _ref;

  AppRouter(this._ref);

  @override
  List<AutoRoute> get routes => [
        // Rotas públicas (não protegidas)
        AutoRoute(
          path: '/intro',
          page: IntroRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: '/signup',
          page: SignupRoute.page,
        ),
        AutoRoute(
          path: '/forgot-password',
          page: ForgotPasswordRoute.page,
        ),
        AutoRoute(
          path: '/reset-password',
          page: ResetPasswordRoute.page,
        ),
        
        // Rotas protegidas (requerem autenticação)
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/workouts',
          page: WorkoutListRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/nutrition',
          page: NutritionRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/profile',
          page: ProfileRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/featured-content/:id',
          page: FeaturedContentDetailRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        
        // Rotas de Benefícios (protegidas)
        AutoRoute(
          path: '/benefits',
          page: BenefitsListRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/benefits/detail',
          page: BenefitDetailRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/benefits/redeemed',
          page: RedeemedBenefitsRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/benefits/redeemed/detail',
          page: RedeemedBenefitDetailRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        
        // Rotas de Desafios (protegidas)
        AutoRoute(
          path: '/challenges',
          page: ChallengesListRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/:challengeId',
          page: ChallengeDetailRoute.page,
          guards: [AuthGuard(_ref)],
        ),
        AutoRoute(
          path: '/challenges/form/:id?',
          page: ChallengeFormRoute.page,
          guards: [AuthGuard(_ref)],
        ),
      ];
}

// Helper class para navegação
class AppRouterHelper {
  static void navigateTo(BuildContext context, String path) {
    AutoRouter.of(context).navigateNamed(path);
  }
  
  static void replaceWith(BuildContext context, String path) {
    AutoRouter.of(context).replaceNamed(path);
  }
  
  static void popAndPush(BuildContext context, String path) {
    AutoRouter.of(context).popAndPushNamed(path);
  }
  
  static void pop(BuildContext context) {
    AutoRouter.of(context).pop();
  }
}
