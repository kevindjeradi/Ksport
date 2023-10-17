import 'package:flutter/material.dart';

class TodaysWorkout extends StatelessWidget {
  // This is just a sample workout list. Replace it with dynamic data.
  final List<Map<String, dynamic>> workouts = [
    {'name': 'Pompes', 'series': 3, 'reps': 10},
    {'name': 'Tractions', 'series': 3, 'reps': 15},
    {'name': 'Squats', 'series': 3, 'reps': 15},
    {'name': 'Curl', 'series': 3, 'reps': 15},
  ];

  TodaysWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Entraînement du jour", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return ListTile(
                leading: Image.network('https://via.placeholder.com/100x30',
                    fit: BoxFit.cover, height: 30),
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
