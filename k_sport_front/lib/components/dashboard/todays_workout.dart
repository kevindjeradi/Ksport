import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:provider/provider.dart';

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
      if (mounted) {
        final trainingProvider =
            Provider.of<ScheduleTrainingProvider>(context, listen: false);

        // Get training of the day directly from the provider
        final training = trainingProvider.getTrainingForDay(day);
        if (training != null) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainingProvider = context.watch<ScheduleTrainingProvider>();
    final workouts = trainingProvider.todayWorkouts;

    return Column(
      children: [
        const Text("Entraînement du jour", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const CircularProgressIndicator()
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
