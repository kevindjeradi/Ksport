import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
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
      appBar: const CustomAppBar(
        title: "Mes entraînements",
        position: 'left',
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
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
    );
  }

  Widget _buildTrainingList(List<Training> trainings) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: trainings.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.all(16.0),
              leading: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.error,
                ),
                onPressed: () async {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Êtes-vous sûr ?'),
                        content: const Text(
                            'Voulez-vous vraiment supprimer cet entraînement ?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Annuler',
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground)),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Supprimer',
                                style: TextStyle(
                                    color: theme.colorScheme.onBackground)),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDelete) {
                    await Api()
                        .delete('$baseUrl/trainings/${trainings[index].id}');
                    setState(() {
                      trainings.removeAt(index);
                    });
                  }
                },
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trainings[index].name,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trainings[index].description,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              onTap: () {
                CustomNavigation.push(context,
                        TrainingForm(editingTraining: trainings[index]))
                    .then((_) => _fetchTrainings());
              },
            ),
          );
        },
      ),
    );
  }
}
