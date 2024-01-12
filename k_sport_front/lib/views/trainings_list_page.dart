import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  static final String baseUrl = dotenv.env['API_URL'] ??
      'http://10.0.2.2:3000'; // Default URL if .env is not loaded

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
  }

  _fetchTrainings() async {
    final response = await Api().get('$baseUrl/trainings');
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          var jsonResponse = jsonDecode(response.body);
          trainings = jsonResponse
              .map<Training>((training) => Training.fromJson(training))
              .toList();
        });
      }
    } else {
      throw Exception('Failed to load trainings');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              label: 'test Créer un nouvel entraînement',
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
      physics: const BouncingScrollPhysics(),
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
              await Api().delete('$baseUrl/trainings/${trainings[index].id}');
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
