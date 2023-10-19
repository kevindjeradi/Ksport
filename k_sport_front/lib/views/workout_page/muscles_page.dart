import 'package:flutter/material.dart';
import 'package:k_sport_front/components/workouts/muscle_grid.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/services/fetch_muscles.dart';

class MusclesPage extends StatelessWidget {
  const MusclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Choisir un muscle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: FutureBuilder<List<Muscle>>(
                future: fetchMuscles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No workouts found.'));
                  } else {
                    return MuscleGrid(muscles: snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
