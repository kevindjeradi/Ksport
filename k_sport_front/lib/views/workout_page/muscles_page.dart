//muscles_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/exercices/muscle_grid.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/muscles/muscle_group_list.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/views/workout_page/create_muscle_page.dart';
import 'package:k_sport_front/views/workout_page/exercice_page.dart';

class MusclesPage extends StatelessWidget {
  final bool isSelectionMode;
  const MusclesPage({super.key, this.isSelectionMode = false});

  void _onGroupSelected(String group, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExercisesPage(
        muscleLabel: group,
        isGroup: true,
        isSelectionMode: isSelectionMode,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: isSelectionMode
          ? ReturnAppBar(
              bgColor: theme.colorScheme.primary,
              barTitle: "Choisir un muscle",
              color: theme.colorScheme.onPrimary)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isSelectionMode
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Choisir un groupe ou un muscle',
                        style: theme.textTheme.displaySmall),
                  ),
            MuscleGroupList(
                onGroupSelected: (group) => _onGroupSelected(group, context)),
            Expanded(
              child: FutureBuilder<List<Muscle>>(
                future: Api().fetchMuscles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CustomLoader());
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondaryContainer,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreateMusclePage(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
