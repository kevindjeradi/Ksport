// muscle_grid.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/exercices/workout_card.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/views/workout_page/exercice_page.dart';

class MuscleGrid extends StatelessWidget {
  final List<Muscle> muscles;
  final bool isSelectionMode;

  const MuscleGrid(
      {Key? key, required this.muscles, this.isSelectionMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(10.0),
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      children: muscles.map((muscle) {
        return WorkoutCard(
          image: Image.network(muscle.imageUrl),
          label: muscle.label,
          onTap: () {
            CustomNavigation.push(
                context,
                ExercisesPage(
                    isSelectionMode: isSelectionMode,
                    muscleLabel: muscle.label.toString()));
          },
        );
      }).toList(),
    );
  }
}
