// exercice_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/components/exercices/workout_card.dart';
import 'package:k_sport_front/components/exercices/workout_card_detail.dart';
import 'package:k_sport_front/models/exercices.dart';
import 'package:k_sport_front/services/api.dart';

class ExercisesPage extends StatelessWidget {
  final String muscleLabel;
  final bool isSelectionMode;

  const ExercisesPage(
      {Key? key, required this.muscleLabel, this.isSelectionMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ReturnAppBar(
          barTitle: "Exercices",
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Exercice>>(
          future: Api.fetchExercisesByMuscle(muscleLabel),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No exercises found.'));
            } else {
              return GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(10.0),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: snapshot.data!.map((exercise) {
                  return WorkoutCard(
                    image: Image.network(exercise.imageUrl),
                    label: exercise.label,
                    onTap: () {
                      if (isSelectionMode) {
                        Navigator.of(context)
                            .pop(exercise); // Pop the ExercisesPage
                        Navigator.of(context)
                            .pop(exercise); // Pop the MusclesPage
                      } else {
                        CustomNavigation.push(
                            context,
                            WorkoutCardDetail(
                              title: exercise.detailTitle,
                              muscleLabel: exercise.muscleLabel,
                              image: Image.network(exercise.imageUrl),
                              description: exercise.detailDescription,
                            ));
                      }
                    },
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
