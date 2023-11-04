import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercices',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Entrainements',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Mes progrès',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor:
          theme.colorScheme.onBackground, // Highlight color for active tab
      unselectedItemColor: Colors.grey, // Non-active items color
      backgroundColor: theme.colorScheme.surface,
    );
  }
}
