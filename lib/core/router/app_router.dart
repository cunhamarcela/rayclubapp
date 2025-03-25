import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ray_club_app/features/home/screens/featured_content_detail_screen.dart';
import 'package:ray_club_app/features/home/screens/home_screen.dart';
import 'package:ray_club_app/features/intro/screens/intro_screen.dart';
import 'package:ray_club_app/features/nutrition/screens/nutrition_screen.dart';
import 'package:ray_club_app/features/profile/screens/profile_screen.dart';
import 'package:ray_club_app/features/workout/screens/workout_list_screen.dart';
import 'package:ray_club_app/features/auth/screens/login_screen.dart';
import 'package:ray_club_app/features/auth/screens/signup_screen.dart';
import 'package:ray_club_app/features/auth/screens/forgot_password_screen.dart';
import 'package:ray_club_app/features/benefits/screens/benefits_list_screen.dart';
import 'package:ray_club_app/features/benefits/screens/benefit_detail_screen.dart';
import 'package:ray_club_app/features/benefits/screens/redeemed_benefits_screen.dart';
import 'package:ray_club_app/features/benefits/screens/redeemed_benefit_detail_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/intro',
          page: IntroRoute.page,
          initial: true,
        ),
        // Auth Routes
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/signup',
          page: SignupRoute.page,
        ),
        AutoRoute(
          path: '/forgot-password',
          page: ForgotPasswordRoute.page,
        ),
        // Main App Routes
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
        ),
        AutoRoute(
          path: '/workouts',
          page: WorkoutListRoute.page,
        ),
        AutoRoute(
          path: '/nutrition',
          page: NutritionRoute.page,
        ),
        AutoRoute(
          path: '/profile',
          page: ProfileRoute.page,
        ),
        AutoRoute(
          path: '/featured-content/:id',
          page: FeaturedContentDetailRoute.page,
        ),
        // Rotas de Benefícios
        AutoRoute(
          path: '/benefits',
          page: BenefitsListRoute.page,
        ),
        AutoRoute(
          path: '/benefits/detail',
          page: BenefitDetailRoute.page,
        ),
        AutoRoute(
          path: '/benefits/redeemed',
          page: RedeemedBenefitsRoute.page,
        ),
        AutoRoute(
          path: '/benefits/redeemed/detail',
          page: RedeemedBenefitDetailRoute.page,
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
