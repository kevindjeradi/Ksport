import 'package:flutter/material.dart';
import 'package:k_sport_front/components/workouts/workout_card.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: [
          WorkoutCard(
              image: Image.network('https://via.placeholder.com/150x150'),
              label: 'Quadriceps',
              onTap: () {}),
          WorkoutCard(
              image: Image.network('https://via.placeholder.com/150x150'),
              label: 'Ischios',
              onTap: () {}),
          WorkoutCard(
              image: Image.network('https://via.placeholder.com/150x150'),
              label: 'Biceps',
              onTap: () {}),
          WorkoutCard(
              image: Image.network('https://via.placeholder.com/150x150'),
              label: 'Triceps',
              onTap: () {})
        ],
      ),
    );
  }
}
