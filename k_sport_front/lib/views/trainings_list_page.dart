import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/trainings/trainings_form.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/services/api.dart';

class TrainingsListPage extends StatefulWidget {
  const TrainingsListPage({super.key});

  @override
  TrainingsListPageState createState() => TrainingsListPageState();
}

class TrainingsListPageState extends State<TrainingsListPage> {
  List<Training> trainings = [];

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
  }

  _fetchTrainings() async {
    final response = await Api.get('http://10.0.2.2:3000/trainings');
    print(
        "\n\n---------------response code: ${response.statusCode}---------------\n\n");
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
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Mes entraînements",
                style: theme.textTheme.displaySmall,
              ),
            ),
            Expanded(child: _buildTrainingList(trainings)),
            const SizedBox(height: 12.0),
            CustomElevatedButton(
              onPressed: () {
                CustomNavigation.push(context, const TrainingForm())
                    .then((_) => _fetchTrainings());
              },
              label: 'Créer un nouvel entraînement',
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingList(List<Training> trainings) {
    ThemeData theme = Theme.of(context);

    return ListView.separated(
      itemCount: trainings.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Text(
            trainings[index].name,
            style: theme.textTheme.headlineSmall,
          ),
          subtitle: Text(
            trainings[index].description,
            style: theme.textTheme.titleMedium,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: theme.colorScheme.error,
            ),
            onPressed: () async {
              await Api.delete(
                  'http://10.0.2.2:3000/trainings/${trainings[index].id}');
              setState(() {
                trainings.removeAt(index);
              });
            },
          ),
          onTap: () {
            CustomNavigation.push(
                    context, TrainingForm(editingTraining: trainings[index]))
                .then((_) => _fetchTrainings());
          },
        );
      },
    );
  }
}
