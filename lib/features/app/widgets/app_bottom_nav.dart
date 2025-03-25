import 'package:flutter/material.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({Key? key}) : super(key: key);

  @override
  _AppBottomNavState createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _navigateToTab(index);
  }

  void _navigateToTab(int index) {
    final navigator = Navigator.of(context);
    
    switch (index) {
      case 0:
        navigator.pushNamedAndRemoveUntil('/home', (route) => false);
        break;
      case 1:
        navigator.pushNamedAndRemoveUntil('/workouts', (route) => false);
        break;
      case 2:
        navigator.pushNamedAndRemoveUntil('/challenges', (route) => false);
        break;
      case 3:
        navigator.pushNamedAndRemoveUntil('/benefits', (route) => false);
        break;
      case 4:
        navigator.pushNamedAndRemoveUntil('/profile', (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: _buildNavItems(),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.fitness_center_outlined),
        activeIcon: Icon(Icons.fitness_center),
        label: 'Treinos',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.emoji_events_outlined),
        activeIcon: Icon(Icons.emoji_events),
        label: 'Desafios',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.card_giftcard_outlined),
        activeIcon: Icon(Icons.card_giftcard),
        label: 'Benefícios',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];
  }
} 