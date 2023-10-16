import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Routine Creator',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Mes progrès',
        ),
      ],
      selectedItemColor: Colors.blue, // Highlight color for active tab
      unselectedItemColor: Colors.grey, // Non-active items color
      backgroundColor: Colors
          .white, // Optional, in case you want to explicitly set the background color
    );
  }
}
