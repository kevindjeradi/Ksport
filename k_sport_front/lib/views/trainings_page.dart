import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/trainings/trainings_form.dart';
import 'package:k_sport_front/models/training.dart';

class TrainingsPage extends StatefulWidget {
  const TrainingsPage({super.key});

  @override
  TrainingsPageState createState() => TrainingsPageState();
}

class TrainingsPageState extends State<TrainingsPage> {
  List<Training> trainings = [];

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
  }

  _fetchTrainings() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/trainings'));
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = jsonDecode(response.body);
        print("\n\n$jsonResponse\n\n");

        trainings = jsonResponse
            .map<Training>((training) => Training.fromJson(training))
            .toList();
      });
    } else {
      throw Exception('Failed to load trainings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Mes entraînements",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(child: _buildTrainingList(trainings)),
            const SizedBox(height: 12.0),
            CustomElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingForm()),
                ).then((_) {
                  _fetchTrainings();
                });
              },
              label: 'Créer un nouvel entraînement',
            ),
            const SizedBox(height: 8.0), // bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingList(List<Training> trainings) {
    return ListView.separated(
      itemCount: trainings.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Text(
            trainings[index].name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(trainings[index].description),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              await http.delete(Uri.parse(
                  'http://10.0.2.2:3000/trainings/${trainings[index].id}'));
              setState(() {
                trainings.removeAt(index);
              });
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TrainingForm(editingTraining: trainings[index])),
            ).then((_) {
              _fetchTrainings();
            });
          },
        );
      },
    );
  }
}
