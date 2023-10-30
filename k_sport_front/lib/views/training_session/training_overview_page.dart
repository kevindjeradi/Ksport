import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
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
      appBar: const ReturnAppBar(
          bgColor: Colors.blue,
          barTitle: "Résumé de la séance",
          color: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: training.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = training.exercises[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://via.placeholder.com/100x30'),
                        ),
                        title: Text(
                          exercise['label'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${exercise['sets']} séries de ${exercise['repetitions']} répétitions',
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainingSessionPage(),
                      ),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  label: 'Commencer la séance',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
