import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/services/training_service.dart';

class TodaysWorkout extends StatefulWidget {
  const TodaysWorkout({super.key});

  @override
  TodaysWorkoutState createState() => TodaysWorkoutState();
}

class TodaysWorkoutState extends State<TodaysWorkout> {
  List<Map<String, dynamic>> workouts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  _loadWorkouts() async {
    try {
      await initializeDateFormatting('fr_FR', null);
      String day =
          DateFormat('EEEE', 'fr_FR').format(DateTime.now()).toLowerCase();
      final training = await TrainingService.fetchTrainingForDay(day);
      if (training != null) {
        setState(() {
          workouts = training.exercises
              .map((exercise) => {
                    'name': exercise['label'],
                    'series': exercise['sets'],
                    'reps': exercise['repetitions'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          workouts = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        workouts = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Entraînement du jour", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return ListTile(
                      leading: Image.network(
                          'https://via.placeholder.com/100x30',
                          fit: BoxFit.cover,
                          height: 30),
                      title: Text(workout['name']),
                      subtitle: Text(
                          '${workout['series']} séries x ${workout['reps']} reps'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
