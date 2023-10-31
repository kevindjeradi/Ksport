// todays_workout.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/views/training_session/training_overview_page.dart';
import 'package:provider/provider.dart';

class TodaysWorkout extends StatefulWidget {
  const TodaysWorkout({super.key});

  @override
  TodaysWorkoutState createState() => TodaysWorkoutState();
}

class TodaysWorkoutState extends State<TodaysWorkout> {
  List<Map<String, dynamic>> workouts = [];
  bool isLoading = false;
  Training? training;
  bool isWorkoutsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWorkouts();
  }

  _loadWorkouts() async {
    if (isWorkoutsLoading) return;

    try {
      isWorkoutsLoading = true;
      await initializeDateFormatting('fr_FR', null);
      String day =
          DateFormat('EEEE', 'fr_FR').format(DateTime.now()).toLowerCase();

      if (mounted) {
        training = await TrainingService.fetchTrainingForDay(day);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      isWorkoutsLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainingProvider = context.watch<ScheduleTrainingProvider>();
    workouts = trainingProvider.todayWorkouts;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return workouts.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Aucun entrainement prévu aujourd'hui",
              style: textTheme.headlineMedium,
            ),
          )
        : InkWell(
            onTap: () {
              if (training != null) {
                CustomNavigation.push(
                    context, TrainingOverviewPage(training: training!));
              } else {
                showCustomSnackBar(
                    context, 'Entrainement introuvable', SnackBarType.error);
              }
            },
            child: Column(
              children: [
                Text(
                  "Entraînement du jour",
                  style: textTheme.headlineMedium,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? const CustomLoader()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: workouts.length,
                          itemBuilder: (context, index) {
                            final workout = workouts[index];
                            return ListTile(
                              leading: Image.network(
                                'https://via.placeholder.com/100x30',
                                fit: BoxFit.cover,
                                height: 30,
                              ),
                              title: Text(
                                workout['name'],
                                style: textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                '${workout['series']} séries x ${workout['reps']} reps',
                                style: textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
  }
}
