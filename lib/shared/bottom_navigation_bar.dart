// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';

// Project imports:
import 'package:ray_club_app/core/constants/app_colors.dart';
import 'package:ray_club_app/core/router/app_router.dart';
import 'package:ray_club_app/features/home/widgets/register_exercise_sheet.dart';

class SharedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const SharedBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index == 2) {
          // Botão central - Registrar Treino
          showRegisterExerciseSheet(context);
          return;
        }
        
        switch (index) {
          case 0:
            context.router.replace(const HomeRoute());
            break;
          case 1:
            context.router.replaceNamed(AppRoutes.workout);
            break;
          case 3:
            context.router.replaceNamed(AppRoutes.nutrition);
            break;
          case 4:
            context.router.replaceNamed(AppRoutes.challenges);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center),
          label: 'Treinos',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Registrar',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: 'Nutrição',
        ),
        NavigationDestination(
          icon: Icon(Icons.emoji_events_outlined),
          selectedIcon: Icon(Icons.emoji_events),
          label: 'Ray 21',
        ),
      ],
    );
  }
} 
