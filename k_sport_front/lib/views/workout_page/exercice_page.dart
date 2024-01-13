// exercice_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/components/exercices/workout_card.dart';
import 'package:k_sport_front/components/exercices/workout_card_detail.dart';
import 'package:k_sport_front/models/exercise.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/views/workout_page/create_exercise_page.dart';

class ExercisesPage extends StatefulWidget {
  final String muscleLabel;
  final bool isSelectionMode;
  final bool isGroup;

  const ExercisesPage({
    Key? key,
    required this.muscleLabel,
    this.isSelectionMode = false,
    this.isGroup = false,
  }) : super(key: key);

  @override
  ExercisesPageState createState() => ExercisesPageState();
}

class ExercisesPageState extends State<ExercisesPage> {
  late Future<List<Exercise>> exercisesFuture;

  @override
  void initState() {
    super.initState();
    exercisesFuture = fetchExercises();
  }

  Future<List<Exercise>> fetchExercises() {
    return widget.isGroup
        ? Api().fetchExercisesByMuscleGroup(widget.muscleLabel)
        : Api().fetchExercisesByMuscle(widget.muscleLabel);
  }

  void refreshExercises() {
    setState(() {
      exercisesFuture = fetchExercises();
    });
  }

  void _navigateAndDisplayCreation(BuildContext context) async {
    final result = await CustomNavigation.push(
        context, CreateExercisePage(muscleLabel: widget.muscleLabel));

    if (result == true) {
      refreshExercises();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const ReturnAppBar(barTitle: "Exercices"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Exercise>>(
          future: exercisesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomLoader());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Aucun exercices pour ce muscle.'));
            } else {
              return GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                padding: const EdgeInsets.all(10.0),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: snapshot.data!.map((exercise) {
                  return WorkoutCard(
                    imageUrl: exercise.imageUrl,
                    label: exercise.label,
                    onTap: () {
                      if (widget.isSelectionMode) {
                        Navigator.of(context).pop(exercise);
                        Navigator.of(context).pop(exercise);
                      } else {
                        CustomNavigation.push(
                          context,
                          WorkoutCardDetail(
                            title: exercise.detailTitle,
                            muscleLabel: exercise.muscleLabel,
                            imageUrl: exercise.imageUrl,
                            description: exercise.detailDescription,
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondaryContainer,
        onPressed: () => _navigateAndDisplayCreation(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
