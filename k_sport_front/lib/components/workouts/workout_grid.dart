import 'package:flutter/material.dart';
import 'package:k_sport_front/components/workouts/workout_card.dart';
import 'package:k_sport_front/components/workouts/workout_card_detail.dart';
import 'package:k_sport_front/models/workout.dart';

class WorkoutGrid extends StatelessWidget {
  final List<Workout> workouts;

  const WorkoutGrid({Key? key, required this.workouts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(10.0),
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      children: workouts.map((workout) {
        return WorkoutCard(
          image: Image.network(workout.imageUrl),
          label: workout.label,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutCardDetail(
                  title: workout.detailTitle,
                  image: Image.network(workout.imageUrl),
                  description: workout.detailDescription,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
