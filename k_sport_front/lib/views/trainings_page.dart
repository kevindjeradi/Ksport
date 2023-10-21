import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      appBar: AppBar(
        title: const Text('Training Creator'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildTrainingList(trainings)),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrainingForm()),
              ).then((_) {
                _fetchTrainings();
              });
            },
            child: const Text('Créer un nouvel entraînement'),
          )
        ],
      ),
    );
  }

  Widget _buildTrainingList(List<Training> trainings) {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(trainings[index].name),
          subtitle: Text(trainings[index].description),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
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
