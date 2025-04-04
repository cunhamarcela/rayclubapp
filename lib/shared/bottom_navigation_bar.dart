import 'package:flutter/material.dart';
import 'package:ray_club_app/core/constants/app_colors.dart';
import 'package:ray_club_app/core/router/app_router.dart';
import 'package:auto_route/auto_route.dart';

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
        switch (index) {
          case 0:
            context.router.replace(const HomeRoute());
            break;
          case 1:
            context.router.replace(const WorkoutListRoute());
            break;
          case 2:
            context.router.replace(const NutritionRoute());
            break;
          case 3:
            context.router.replace(const ProfileRoute());
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
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: 'Nutrição',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
} 