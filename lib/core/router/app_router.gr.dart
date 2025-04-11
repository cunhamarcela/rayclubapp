// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BenefitAdminScreen]
class BenefitAdminRoute extends PageRouteInfo<void> {
  const BenefitAdminRoute({List<PageRouteInfo>? children})
      : super(
          BenefitAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'BenefitAdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BenefitAdminScreen();
    },
  );
}

/// generated route for
/// [BenefitDetailScreen]
class BenefitDetailRoute extends PageRouteInfo<void> {
  const BenefitDetailRoute({List<PageRouteInfo>? children})
      : super(
          BenefitDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'BenefitDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BenefitDetailScreen();
    },
  );
}

/// generated route for
/// [BenefitFormScreen]
class BenefitFormRoute extends PageRouteInfo<BenefitFormRouteArgs> {
  BenefitFormRoute({
    Key? key,
    String? benefitId,
    List<PageRouteInfo>? children,
  }) : super(
          BenefitFormRoute.name,
          args: BenefitFormRouteArgs(
            key: key,
            benefitId: benefitId,
          ),
          rawQueryParams: {'benefitId': benefitId},
          initialChildren: children,
        );

  static const String name = 'BenefitFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<BenefitFormRouteArgs>(
          orElse: () => BenefitFormRouteArgs(
              benefitId: queryParams.optString('benefitId')));
      return BenefitFormScreen(
        key: args.key,
        benefitId: args.benefitId,
      );
    },
  );
}

class BenefitFormRouteArgs {
  const BenefitFormRouteArgs({
    this.key,
    this.benefitId,
  });

  final Key? key;

  final String? benefitId;

  @override
  String toString() {
    return 'BenefitFormRouteArgs{key: $key, benefitId: $benefitId}';
  }
}

/// generated route for
/// [BenefitsListScreen]
class BenefitsListRoute extends PageRouteInfo<void> {
  const BenefitsListRoute({List<PageRouteInfo>? children})
      : super(
          BenefitsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'BenefitsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BenefitsListScreen();
    },
  );
}

/// generated route for
/// [ChallengeDetailScreen]
class ChallengeDetailRoute extends PageRouteInfo<ChallengeDetailRouteArgs> {
  ChallengeDetailRoute({
    Key? key,
    required String challengeId,
    List<PageRouteInfo>? children,
  }) : super(
          ChallengeDetailRoute.name,
          args: ChallengeDetailRouteArgs(
            key: key,
            challengeId: challengeId,
          ),
          rawPathParams: {'id': challengeId},
          initialChildren: children,
        );

  static const String name = 'ChallengeDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChallengeDetailRouteArgs>(
          orElse: () => ChallengeDetailRouteArgs(
              challengeId: pathParams.getString('id')));
      return ChallengeDetailScreen(
        key: args.key,
        challengeId: args.challengeId,
      );
    },
  );
}

class ChallengeDetailRouteArgs {
  const ChallengeDetailRouteArgs({
    this.key,
    required this.challengeId,
  });

  final Key? key;

  final String challengeId;

  @override
  String toString() {
    return 'ChallengeDetailRouteArgs{key: $key, challengeId: $challengeId}';
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChallengeFormRouteArgs>(
          orElse: () =>
              ChallengeFormRouteArgs(challengeId: pathParams.optString('id')));
      return ChallengeFormScreen(
        challengeId: args.challengeId,
        key: args.key,
      );
    },
  );
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
/// [ChallengeGroupDetailScreen]
class ChallengeGroupDetailRoute
    extends PageRouteInfo<ChallengeGroupDetailRouteArgs> {
  ChallengeGroupDetailRoute({
    Key? key,
    required String groupId,
    List<PageRouteInfo>? children,
  }) : super(
          ChallengeGroupDetailRoute.name,
          args: ChallengeGroupDetailRouteArgs(
            key: key,
            groupId: groupId,
          ),
          rawPathParams: {'groupId': groupId},
          initialChildren: children,
        );

  static const String name = 'ChallengeGroupDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChallengeGroupDetailRouteArgs>(
          orElse: () => ChallengeGroupDetailRouteArgs(
              groupId: pathParams.getString('groupId')));
      return ChallengeGroupDetailScreen(
        key: args.key,
        groupId: args.groupId,
      );
    },
  );
}

class ChallengeGroupDetailRouteArgs {
  const ChallengeGroupDetailRouteArgs({
    this.key,
    required this.groupId,
  });

  final Key? key;

  final String groupId;

  @override
  String toString() {
    return 'ChallengeGroupDetailRouteArgs{key: $key, groupId: $groupId}';
  }
}

/// generated route for
/// [ChallengeGroupInvitesScreen]
class ChallengeGroupInvitesRoute extends PageRouteInfo<void> {
  const ChallengeGroupInvitesRoute({List<PageRouteInfo>? children})
      : super(
          ChallengeGroupInvitesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChallengeGroupInvitesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChallengeGroupInvitesScreen();
    },
  );
}

/// generated route for
/// [ChallengeGroupsScreen]
class ChallengeGroupsRoute extends PageRouteInfo<void> {
  const ChallengeGroupsRoute({List<PageRouteInfo>? children})
      : super(
          ChallengeGroupsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChallengeGroupsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChallengeGroupsScreen();
    },
  );
}

/// generated route for
/// [ChallengeInvitesScreen]
class ChallengeInvitesRoute extends PageRouteInfo<ChallengeInvitesRouteArgs> {
  ChallengeInvitesRoute({
    Key? key,
    required String userId,
    List<PageRouteInfo>? children,
  }) : super(
          ChallengeInvitesRoute.name,
          args: ChallengeInvitesRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'ChallengeInvitesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChallengeInvitesRouteArgs>(
          orElse: () => ChallengeInvitesRouteArgs(
              userId: pathParams.getString('userId')));
      return ChallengeInvitesScreen(
        key: args.key,
        userId: args.userId,
      );
    },
  );
}

class ChallengeInvitesRouteArgs {
  const ChallengeInvitesRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'ChallengeInvitesRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [ChallengeRankingScreen]
class ChallengeRankingRoute extends PageRouteInfo<ChallengeRankingRouteArgs> {
  ChallengeRankingRoute({
    Key? key,
    required String challengeId,
    List<PageRouteInfo>? children,
  }) : super(
          ChallengeRankingRoute.name,
          args: ChallengeRankingRouteArgs(
            key: key,
            challengeId: challengeId,
          ),
          rawPathParams: {'challengeId': challengeId},
          initialChildren: children,
        );

  static const String name = 'ChallengeRankingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChallengeRankingRouteArgs>(
          orElse: () => ChallengeRankingRouteArgs(
              challengeId: pathParams.getString('challengeId')));
      return ChallengeRankingScreen(
        key: args.key,
        challengeId: args.challengeId,
      );
    },
  );
}

class ChallengeRankingRouteArgs {
  const ChallengeRankingRouteArgs({
    this.key,
    required this.challengeId,
  });

  final Key? key;

  final String challengeId;

  @override
  String toString() {
    return 'ChallengeRankingRouteArgs{key: $key, challengeId: $challengeId}';
  }
}

/// generated route for
/// [ChallengesAdminScreen]
class ChallengesAdminRoute extends PageRouteInfo<void> {
  const ChallengesAdminRoute({List<PageRouteInfo>? children})
      : super(
          ChallengesAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChallengesAdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChallengesAdminScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChallengesListScreen();
    },
  );
}

/// generated route for
/// [ConsentManagementScreen]
class ConsentManagementRoute extends PageRouteInfo<void> {
  const ConsentManagementRoute({List<PageRouteInfo>? children})
      : super(
          ConsentManagementRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConsentManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ConsentManagementScreen();
    },
  );
}

/// generated route for
/// [CreateChallengeScreen]
class CreateChallengeRoute extends PageRouteInfo<void> {
  const CreateChallengeRoute({List<PageRouteInfo>? children})
      : super(
          CreateChallengeRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateChallengeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateChallengeScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<FeaturedContentDetailRouteArgs>(
          orElse: () => FeaturedContentDetailRouteArgs(
              contentId: pathParams.getString('id')));
      return FeaturedContentDetailScreen(
        key: args.key,
        contentId: args.contentId,
      );
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [GoalFormScreen]
class GoalFormRoute extends PageRouteInfo<GoalFormRouteArgs> {
  GoalFormRoute({
    Key? key,
    UserGoal? existingGoal,
    List<PageRouteInfo>? children,
  }) : super(
          GoalFormRoute.name,
          args: GoalFormRouteArgs(
            key: key,
            existingGoal: existingGoal,
          ),
          initialChildren: children,
        );

  static const String name = 'GoalFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GoalFormRouteArgs>(
          orElse: () => const GoalFormRouteArgs());
      return GoalFormScreen(
        key: args.key,
        existingGoal: args.existingGoal,
      );
    },
  );
}

class GoalFormRouteArgs {
  const GoalFormRouteArgs({
    this.key,
    this.existingGoal,
  });

  final Key? key;

  final UserGoal? existingGoal;

  @override
  String toString() {
    return 'GoalFormRouteArgs{key: $key, existingGoal: $existingGoal}';
  }
}

/// generated route for
/// [HelpScreen]
class HelpRoute extends PageRouteInfo<void> {
  const HelpRoute({List<PageRouteInfo>? children})
      : super(
          HelpRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelpScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntroScreen();
    },
  );
}

/// generated route for
/// [InviteUsersScreen]
class InviteUsersRoute extends PageRouteInfo<InviteUsersRouteArgs> {
  InviteUsersRoute({
    Key? key,
    String challengeId = 'temp-id',
    String challengeTitle = 'Novo Desafio',
    String? currentUserId,
    String? currentUserName,
    List<PageRouteInfo>? children,
  }) : super(
          InviteUsersRoute.name,
          args: InviteUsersRouteArgs(
            key: key,
            challengeId: challengeId,
            challengeTitle: challengeTitle,
            currentUserId: currentUserId,
            currentUserName: currentUserName,
          ),
          initialChildren: children,
        );

  static const String name = 'InviteUsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InviteUsersRouteArgs>(
          orElse: () => const InviteUsersRouteArgs());
      return InviteUsersScreen(
        key: args.key,
        challengeId: args.challengeId,
        challengeTitle: args.challengeTitle,
        currentUserId: args.currentUserId,
        currentUserName: args.currentUserName,
      );
    },
  );
}

class InviteUsersRouteArgs {
  const InviteUsersRouteArgs({
    this.key,
    this.challengeId = 'temp-id',
    this.challengeTitle = 'Novo Desafio',
    this.currentUserId,
    this.currentUserName,
  });

  final Key? key;

  final String challengeId;

  final String challengeTitle;

  final String? currentUserId;

  final String? currentUserName;

  @override
  String toString() {
    return 'InviteUsersRouteArgs{key: $key, challengeId: $challengeId, challengeTitle: $challengeTitle, currentUserId: $currentUserId, currentUserName: $currentUserName}';
  }
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MealDetailScreen]
class MealDetailRoute extends PageRouteInfo<MealDetailRouteArgs> {
  MealDetailRoute({
    Key? key,
    required String mealId,
    List<PageRouteInfo>? children,
  }) : super(
          MealDetailRoute.name,
          args: MealDetailRouteArgs(
            key: key,
            mealId: mealId,
          ),
          rawPathParams: {'id': mealId},
          initialChildren: children,
        );

  static const String name = 'MealDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MealDetailRouteArgs>(
          orElse: () =>
              MealDetailRouteArgs(mealId: pathParams.getString('id')));
      return MealDetailScreen(
        key: args.key,
        mealId: args.mealId,
      );
    },
  );
}

class MealDetailRouteArgs {
  const MealDetailRouteArgs({
    this.key,
    required this.mealId,
  });

  final Key? key;

  final String mealId;

  @override
  String toString() {
    return 'MealDetailRouteArgs{key: $key, mealId: $mealId}';
  }
}

/// generated route for
/// [NotificationSettingsScreen]
class NotificationSettingsRoute extends PageRouteInfo<void> {
  const NotificationSettingsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationSettingsScreen();
    },
  );
}

/// generated route for
/// [NotificationSettingsScreenRefactored]
class NotificationSettingsRouteRefactored extends PageRouteInfo<void> {
  const NotificationSettingsRouteRefactored({List<PageRouteInfo>? children})
      : super(
          NotificationSettingsRouteRefactored.name,
          initialChildren: children,
        );

  static const String name = 'NotificationSettingsRouteRefactored';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationSettingsScreenRefactored();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NutritionScreen();
    },
  );
}

/// generated route for
/// [PrivacyPolicyScreen]
class PrivacyPolicyRoute extends PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<PageRouteInfo>? children})
      : super(
          PrivacyPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPolicyScreen();
    },
  );
}

/// generated route for
/// [ProfileEditScreen]
class ProfileEditRoute extends PageRouteInfo<void> {
  const ProfileEditRoute({List<PageRouteInfo>? children})
      : super(
          ProfileEditRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileEditScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [ProgressPlanScreen]
class ProgressPlanRoute extends PageRouteInfo<void> {
  const ProgressPlanRoute({List<PageRouteInfo>? children})
      : super(
          ProgressPlanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProgressPlanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProgressPlanScreen();
    },
  );
}

/// generated route for
/// [RealtimeChallengeDetailScreen]
class RealtimeChallengeDetailRoute
    extends PageRouteInfo<RealtimeChallengeDetailRouteArgs> {
  RealtimeChallengeDetailRoute({
    required String challengeId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          RealtimeChallengeDetailRoute.name,
          args: RealtimeChallengeDetailRouteArgs(
            challengeId: challengeId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'RealtimeChallengeDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RealtimeChallengeDetailRouteArgs>();
      return RealtimeChallengeDetailScreen(
        challengeId: args.challengeId,
        key: args.key,
      );
    },
  );
}

class RealtimeChallengeDetailRouteArgs {
  const RealtimeChallengeDetailRouteArgs({
    required this.challengeId,
    this.key,
  });

  final String challengeId;

  final Key? key;

  @override
  String toString() {
    return 'RealtimeChallengeDetailRouteArgs{challengeId: $challengeId, key: $key}';
  }
}

/// generated route for
/// [RecipeDetailScreen]
class RecipeDetailRoute extends PageRouteInfo<RecipeDetailRouteArgs> {
  RecipeDetailRoute({
    Key? key,
    required String recipeId,
    required Map<String, dynamic> recipe,
    List<PageRouteInfo>? children,
  }) : super(
          RecipeDetailRoute.name,
          args: RecipeDetailRouteArgs(
            key: key,
            recipeId: recipeId,
            recipe: recipe,
          ),
          rawPathParams: {'id': recipeId},
          initialChildren: children,
        );

  static const String name = 'RecipeDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecipeDetailRouteArgs>();
      return RecipeDetailScreen(
        key: args.key,
        recipeId: args.recipeId,
        recipe: args.recipe,
      );
    },
  );
}

class RecipeDetailRouteArgs {
  const RecipeDetailRouteArgs({
    this.key,
    required this.recipeId,
    required this.recipe,
  });

  final Key? key;

  final String recipeId;

  final Map<String, dynamic> recipe;

  @override
  String toString() {
    return 'RecipeDetailRouteArgs{key: $key, recipeId: $recipeId, recipe: $recipe}';
  }
}

/// generated route for
/// [RedeemedBenefitDetailScreen]
class RedeemedBenefitDetailRoute extends PageRouteInfo<void> {
  const RedeemedBenefitDetailRoute({List<PageRouteInfo>? children})
      : super(
          RedeemedBenefitDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'RedeemedBenefitDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RedeemedBenefitDetailScreen();
    },
  );
}

/// generated route for
/// [RedeemedBenefitsScreen]
class RedeemedBenefitsRoute extends PageRouteInfo<void> {
  const RedeemedBenefitsRoute({List<PageRouteInfo>? children})
      : super(
          RedeemedBenefitsRoute.name,
          initialChildren: children,
        );

  static const String name = 'RedeemedBenefitsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RedeemedBenefitsScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupScreen();
    },
  );
}

/// generated route for
/// [TermsOfUseScreen]
class TermsOfUseRoute extends PageRouteInfo<void> {
  const TermsOfUseRoute({List<PageRouteInfo>? children})
      : super(
          TermsOfUseRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsOfUseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TermsOfUseScreen();
    },
  );
}

/// generated route for
/// [UserSelectionScreen]
class UserSelectionRoute extends PageRouteInfo<void> {
  const UserSelectionRoute({List<PageRouteInfo>? children})
      : super(
          UserSelectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserSelectionScreen();
    },
  );
}

/// generated route for
/// [WorkoutCategoriesScreen]
class WorkoutCategoriesRoute extends PageRouteInfo<void> {
  const WorkoutCategoriesRoute({List<PageRouteInfo>? children})
      : super(
          WorkoutCategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'WorkoutCategoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkoutCategoriesScreen();
    },
  );
}

/// generated route for
/// [WorkoutDetailScreen]
class WorkoutDetailRoute extends PageRouteInfo<WorkoutDetailRouteArgs> {
  WorkoutDetailRoute({
    Key? key,
    required String workoutId,
    List<PageRouteInfo>? children,
  }) : super(
          WorkoutDetailRoute.name,
          args: WorkoutDetailRouteArgs(
            key: key,
            workoutId: workoutId,
          ),
          rawPathParams: {'id': workoutId},
          initialChildren: children,
        );

  static const String name = 'WorkoutDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WorkoutDetailRouteArgs>(
          orElse: () =>
              WorkoutDetailRouteArgs(workoutId: pathParams.getString('id')));
      return WorkoutDetailScreen(
        key: args.key,
        workoutId: args.workoutId,
      );
    },
  );
}

class WorkoutDetailRouteArgs {
  const WorkoutDetailRouteArgs({
    this.key,
    required this.workoutId,
  });

  final Key? key;

  final String workoutId;

  @override
  String toString() {
    return 'WorkoutDetailRouteArgs{key: $key, workoutId: $workoutId}';
  }
}

/// generated route for
/// [WorkoutHistoryScreen]
class WorkoutHistoryRoute extends PageRouteInfo<void> {
  const WorkoutHistoryRoute({List<PageRouteInfo>? children})
      : super(
          WorkoutHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'WorkoutHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkoutHistoryScreen();
    },
  );
}

/// generated route for
/// [WorkoutListScreen]
class WorkoutListRoute extends PageRouteInfo<void> {
  const WorkoutListRoute({List<PageRouteInfo>? children})
      : super(
          WorkoutListRoute.name,
          initialChildren: children,
        );

  static const String name = 'WorkoutListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WorkoutListScreen();
    },
  );
}
