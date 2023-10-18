import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/components/workouts/workout_card.dart';
import 'package:k_sport_front/models/exercices.dart';
import 'package:k_sport_front/services/fetch_exercices.dart'; // Make sure this is the correct path to the service

class ExercisesPage extends StatelessWidget {
  final String muscleId;

  const ExercisesPage({Key? key, required this.muscleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Exercices',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: FutureBuilder<List<Exercice>>(
                future: fetchExercices(muscleId),
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
                            // Add a onTap behavior if needed
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
