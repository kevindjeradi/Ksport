import 'package:flutter/material.dart';
import 'package:k_sport_front/components/workouts/workout_card.dart';
import 'package:k_sport_front/components/workouts/workout_card_detail.dart';
import 'package:k_sport_front/models/exercices.dart';

class ExerciceGrid extends StatelessWidget {
  final List<Exercice> exercices;

  const ExerciceGrid({Key? key, required this.exercices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(10.0),
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      children: exercices.map((exercice) {
        return WorkoutCard(
          image: Image.network(exercice.imageUrl),
          label: exercice.label,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutCardDetail(
                    title: exercice.detailTitle,
                    image: Image.network(exercice.imageUrl)),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
