import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/trainings/training_schedule_card.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ScheduleComponent extends StatefulWidget {
  final Function(int) onDayTapped;
  final Function(int, Training?) onTrainingAssigned;

  const ScheduleComponent(
      {Key? key, required this.onDayTapped, required this.onTrainingAssigned})
      : super(key: key);

  @override
  ScheduleComponentState createState() => ScheduleComponentState();
}

class ScheduleComponentState extends State<ScheduleComponent> {
  List<Status> weekStatuses = List.filled(7, Status.coming);

  @override
  void initState() {
    super.initState();
    // Initialize weekStatuses with Status.coming for all days.
    weekStatuses = List.filled(7, Status.coming);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final trainingProvider =
          Provider.of<ScheduleTrainingProvider>(context, listen: false);

      await trainingProvider.fetchTrainings();
      // Fetch all trainings scheduled for the week.
      await trainingProvider.fetchAllTrainingsForTheWeek();

      // Get today's weekday number.
      int today = DateTime.now().weekday;

      // Update the statuses for the week based on the completed trainings.
      if (context.mounted) {
        setState(() {
          weekStatuses = List.generate(7, (index) {
            // For days in the past, check if a training was completed.
            if (index < today - 1) {
              DateTime dayDate =
                  DateTime.now().subtract(Duration(days: today - index - 1));
              // Check if there is a completed training for this day.
              bool trainingCompleted = userProvider.completedTrainings?.any(
                      (completedTraining) =>
                          completedTraining.dateCompleted.year ==
                              dayDate.year &&
                          completedTraining.dateCompleted.month ==
                              dayDate.month &&
                          completedTraining.dateCompleted.day == dayDate.day) ??
                  false;

              // Return Status.checked if training was completed, otherwise Status.missed.
              return trainingCompleted ? Status.checked : Status.missed;
            } else if (index == today - 1) {
              // Return Status.current for the current day.
              return Status.current;
            } else {
              // Future days remain as Status.coming.
              return Status.coming;
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ScheduleTrainingProvider>(
      builder: (context, trainingProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Planning',
                    style: theme.textTheme.headlineMedium,
                  ),
                  Text(
                    'cette semaine',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              trainingProvider.isLoading
                  ? const Center(child: CustomLoader())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weekStatuses
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildDay(
                                entry.key, entry.value, trainingProvider),
                          )
                          .toList(),
                    ),
              if (trainingProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    trainingProvider.errorMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDay(
      int index, Status status, ScheduleTrainingProvider trainingProvider) {
    ThemeData theme = Theme.of(context);
    Training? selectedTraining;
    String dayName = ScheduleTrainingProvider.dayNames[index];
    Training? currentTraining = trainingProvider.weekTrainings[index];
    bool isEmpty = currentTraining?.name.isEmpty ?? true;
    String selectedTrainingName = '';
    Color bgColor;
    IconData icon = Icons.circle;
    Color textColor = Colors.white;
    BoxBorder containerBorder =
        Border.all(width: 0, color: theme.colorScheme.background);

    switch (status) {
      case Status.checked:
        bgColor = theme.colorScheme.primary.withOpacity(0.9);
        icon = Icons.check_circle;
        break;
      case Status.missed:
        bgColor = theme.colorScheme.error.withOpacity(0.9);
        icon = Icons.cancel;
        break;
      case Status.current:
        bgColor = theme.colorScheme.surface;
        textColor = theme.colorScheme.onBackground;
        containerBorder =
            Border.all(width: 1.0, color: theme.colorScheme.onBackground);
        break;
      case Status.coming:
        bgColor = theme.colorScheme.background;
        textColor = theme.colorScheme.onBackground.withOpacity(0.3);
        containerBorder = Border.all(
            width: 1.0, color: theme.colorScheme.onBackground.withOpacity(0.2));
        break;
    }

    return InkWell(
      onTap: () {
        if (status == Status.missed) {
          showCustomSnackBar(
            context,
            'Le passé est passé, il fallait mieux t\'organiser.',
            SnackBarType.info,
          );
        } else if (status == Status.checked) {
          showCustomSnackBar(
            context,
            'Le passé est passé, va plutôt voir du côté de ton historique.',
            SnackBarType.info,
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return LayoutBuilder(builder: (context, constraints) {
                  return AlertDialog(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: theme.cardTheme.color,
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.assignment,
                                color: theme.iconTheme.color,
                                size: 24.0,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                dayName,
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            child: TextButton(
                              onPressed: () {
                                if (trainingProvider.todayWorkouts.isEmpty) {
                                  Navigator.of(context).pop();
                                  showCustomSnackBar(
                                      context,
                                      'Aucun entrainement à supprimer',
                                      SnackBarType.info);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Supprimer l\'entrainement'),
                                          content: const Text(
                                              'Voulez vous supprimer l\'entrainement prévu ?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Non'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Call deleteTrainingForDay method from provider
                                                trainingProvider
                                                    .deleteTrainingForDay(
                                                        index);
                                                showCustomSnackBar(
                                                    context,
                                                    'Entrainement prévu supprimé!',
                                                    SnackBarType.success);

                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Oui',
                                                  style: TextStyle(
                                                      color: theme
                                                          .colorScheme.error)),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                              child: Text("suppr",
                                  style: TextStyle(
                                      color: theme.colorScheme.error)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    content: SizedBox(
                      height: 400,
                      child: trainingProvider.isLoading
                          ? const Center(child: CustomLoader())
                          : trainingProvider.errorMessage.isNotEmpty
                              ? Text(
                                  trainingProvider.errorMessage,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                )
                              : SizedBox(
                                  width: constraints.maxWidth * 0.8,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isEmpty
                                          ? Text(
                                              'Aucun entrainement selectionné',
                                              style: theme.textTheme.bodyMedium,
                                            )
                                          : Center(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: theme.colorScheme
                                                          .onBackground),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: status ==
                                                                Status.current
                                                            ? 'Aujourd\'hui, c\'est '
                                                            : 'Ce jour là ça sera '),
                                                    TextSpan(
                                                      text: selectedTrainingName ==
                                                              ''
                                                          ? currentTraining
                                                              ?.name
                                                              .toUpperCase()
                                                          : selectedTrainingName
                                                              .toUpperCase(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: theme.colorScheme
                                                            .onBackground,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 20),
                                      Expanded(
                                          child: Scrollbar(
                                        thumbVisibility: true,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  2, // Adjust the number of columns as needed
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                            ),
                                            itemCount: trainingProvider
                                                .trainings.length,
                                            itemBuilder: (BuildContext context,
                                                int gridIndex) {
                                              Training training =
                                                  trainingProvider
                                                      .trainings[gridIndex];
                                              bool isSelected =
                                                  selectedTraining == training;
                                              return TrainingCard(
                                                training: training,
                                                isSelected: isSelected,
                                                onTap: () async {
                                                  setState(() {
                                                    selectedTraining = training;
                                                    selectedTrainingName =
                                                        selectedTraining!.name;
                                                    Log.logger.i(
                                                        "index: $index\nnewValue: $training");
                                                    trainingProvider
                                                        .updateTrainingForDay(
                                                            index, training);
                                                  });
                                                  await widget
                                                      .onTrainingAssigned(
                                                          index + 1, training);
                                                  // Optionally close the dialog or provide other feedback
                                                  // Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK',
                            style: TextStyle(
                                color: theme.colorScheme.onBackground)),
                      ),
                    ],
                    contentPadding: const EdgeInsets.all(20),
                    insetPadding: const EdgeInsets.all(20),
                  );
                });
              });
            },
          );
          widget.onDayTapped(index + 1);
        }
      },
      child: Container(
        width: 45,
        height: 55,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
            border: containerBorder),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(dayName.substring(0, 3), style: TextStyle(color: textColor)),
            const SizedBox(width: 5),
            icon != Icons.circle
                ? Icon(icon, size: 18, color: textColor)
                : Icon(icon, size: 10, color: textColor)
          ],
        ),
      ),
    );
  }
}

enum Status { checked, current, coming, missed }
