//muscles_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/exercices/muscle_grid.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/services/api.dart';

class MusclesPage extends StatelessWidget {
  final bool isSelectionMode;
  const MusclesPage({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode
          ? const ReturnAppBar(
              bgColor: Colors.blue,
              barTitle: "Choisir un muscle",
              color: Colors.white)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isSelectionMode
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Choisir un muscle',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
            Expanded(
              child: FutureBuilder<List<Muscle>>(
                future: Api.fetchMuscles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No workouts found.'));
                  } else {
                    return MuscleGrid(
                        muscles: snapshot.data!,
                        isSelectionMode: isSelectionMode);
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
