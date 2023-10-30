import 'package:flutter/material.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/views/training_session/training_session_page.dart';

class TrainingOverviewPage extends StatelessWidget {
  final Training training;

  const TrainingOverviewPage({Key? key, required this.training})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("\n\n\nNom de l'entrainement -> ${training.name}\n\n\n");
    print("\n\n\nNombre d'exos -> ${training.exercises.length}\n");
    print("\n\n\nNom de l'exercice 1 -> ${training.exercises[0]['label']}\n");
    print("\n\n\nNombre de series exo 1 -> ${training.exercises[0]['sets']}\n");
    print(
        "\n\n\nNombres de series -> ${training.exercises[0]['repetitions']}\n\n");
    return Scaffold(
      appBar: AppBar(
        title: Text(training.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: training.exercises.length,
              itemBuilder: (context, index) {
                final exercise = training.exercises[index];
                return ListTile(
                  leading: Image.network(
                    'https://via.placeholder.com/100x30',
                    fit: BoxFit.cover,
                    height: 30,
                  ),
                  title: Text(exercise['label']),
                  subtitle: Text(
                      '${exercise['sets']} séries x ${exercise['repetitions']} reps'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainingSessionPage(),
                  ),
                );
              },
              child: const Text('Commencer la séance'),
            ),
          ),
        ],
      ),
    );
  }
}
