// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ChallengeDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChallengeDetailRouteArgs>(
          orElse: () => ChallengeDetailRouteArgs(
              challengeId: pathParams.getString('challengeId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChallengeDetailScreen(
          challengeId: args.challengeId,
          key: args.key,
        ),
      );
    },
    ChallengeFormRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChallengeFormRouteArgs>(
          orElse: () =>
              ChallengeFormRouteArgs(challengeId: pathParams.optString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChallengeFormScreen(
          challengeId: args.challengeId,
          key: args.key,
        ),
      );
    },
    ChallengesListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChallengesListScreen(),
      );
    },
    FeaturedContentDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<FeaturedContentDetailRouteArgs>(
          orElse: () => FeaturedContentDetailRouteArgs(
              contentId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FeaturedContentDetailScreen(
          key: args.key,
          contentId: args.contentId,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    IntroRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const IntroScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    NutritionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NutritionScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResetPasswordScreen(),
      );
    },
    SignupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignupScreen(),
      );
    },
  };
}

/// generated route for
/// [ChallengeDetailScreen]
class ChallengeDetailRoute extends PageRouteInfo<ChallengeDetailRouteArgs> {
  ChallengeDetailRoute({
    required String challengeId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChallengeDetailRoute.name,
          args: ChallengeDetailRouteArgs(
            challengeId: challengeId,
            key: key,
          ),
          rawPathParams: {'challengeId': challengeId},
          initialChildren: children,
        );

  static const String name = 'ChallengeDetailRoute';

  static const PageInfo<ChallengeDetailRouteArgs> page =
      PageInfo<ChallengeDetailRouteArgs>(name);
}

class ChallengeDetailRouteArgs {
  const ChallengeDetailRouteArgs({
    required this.challengeId,
    this.key,
  });

  final String challengeId;

  final Key? key;

  @override
  String toString() {
    return 'ChallengeDetailRouteArgs{challengeId: $challengeId, key: $key}';
  }
}

/// generated route for
/// [ChallengeFormScreen]
class ChallengeFormRoute extends PageRouteInfo<ChallengeFormRouteArgs> {
  ChallengeFormRoute({
    String? challengeId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChallengeFormRoute.name,
          args: ChallengeFormRouteArgs(
            challengeId: challengeId,
            key: key,
          ),
          rawPathParams: {'id': challengeId},
          initialChildren: children,
        );

  static const String name = 'ChallengeFormRoute';

  static const PageInfo<ChallengeFormRouteArgs> page =
      PageInfo<ChallengeFormRouteArgs>(name);
}

class ChallengeFormRouteArgs {
  const ChallengeFormRouteArgs({
    this.challengeId,
    this.key,
  });

  final String? challengeId;

  final Key? key;

  @override
  String toString() {
    return 'ChallengeFormRouteArgs{challengeId: $challengeId, key: $key}';
  }
}

/// generated route for
/// [ChallengesListScreen]
class ChallengesListRoute extends PageRouteInfo<void> {
  const ChallengesListRoute({List<PageRouteInfo>? children})
      : super(
          ChallengesListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChallengesListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FeaturedContentDetailScreen]
class FeaturedContentDetailRoute
    extends PageRouteInfo<FeaturedContentDetailRouteArgs> {
  FeaturedContentDetailRoute({
    Key? key,
    required String contentId,
    List<PageRouteInfo>? children,
  }) : super(
          FeaturedContentDetailRoute.name,
          args: FeaturedContentDetailRouteArgs(
            key: key,
            contentId: contentId,
          ),
          rawPathParams: {'id': contentId},
          initialChildren: children,
        );

  static const String name = 'FeaturedContentDetailRoute';

  static const PageInfo<FeaturedContentDetailRouteArgs> page =
      PageInfo<FeaturedContentDetailRouteArgs>(name);
}

class FeaturedContentDetailRouteArgs {
  const FeaturedContentDetailRouteArgs({
    this.key,
    required this.contentId,
  });

  final Key? key;

  final String contentId;

  @override
  String toString() {
    return 'FeaturedContentDetailRouteArgs{key: $key, contentId: $contentId}';
  }
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [IntroScreen]
class IntroRoute extends PageRouteInfo<void> {
  const IntroRoute({List<PageRouteInfo>? children})
      : super(
          IntroRoute.name,
          initialChildren: children,
        );

  static const String name = 'IntroRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NutritionScreen]
class NutritionRoute extends PageRouteInfo<void> {
  const NutritionRoute({List<PageRouteInfo>? children})
      : super(
          NutritionRoute.name,
          initialChildren: children,
        );

  static const String name = 'NutritionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
