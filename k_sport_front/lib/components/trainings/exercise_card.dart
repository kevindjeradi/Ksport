import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  final TextEditingController labelController;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final TextEditingController restTimeController;
  final VoidCallback onRemove;
  final Function updateRepsControllers;
  final Function updateWeightControllers;
  final Function updateRestTimeControllers;
  final Function addError;

  const ExerciseCard({
    Key? key,
    required this.labelController,
    required this.setsController,
    required this.repsController,
    required this.weightController,
    required this.restTimeController,
    required this.onRemove,
    required this.updateRepsControllers,
    required this.updateWeightControllers,
    required this.updateRestTimeControllers,
    required this.addError,
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool isExpanded = false;
  late TextEditingController setsController;
  late List<TextEditingController> repsControllers;
  late List<TextEditingController> weightControllers;
  late List<TextEditingController> restTimeControllers;

  bool isUpdatingControllers = false;
  VoidCallback? repsFirstControllerListener;
  VoidCallback? weightFirstControllerListener;
  VoidCallback? restTimeFirstControllerListener;

  @override
  void initState() {
    super.initState();
    setsController = widget.setsController;

    int initialSets = int.tryParse(setsController.text) ?? 0;

    // Parse existing values
    List<String> repsValues = widget.repsController.text.split(',');
    List<String> weightValues = widget.weightController.text.split(',');
    List<String> restTimeValues = widget.restTimeController.text.split(',');

    // Initialize controllers with existing values
    repsControllers = List.generate(initialSets, (index) {
      String text = index < repsValues.length ? repsValues[index] : '';
      final controller = TextEditingController(text: text);
      controller.addListener(() {
        widget.repsController.text =
            repsControllers.map((e) => e.text).join(',');
      });
      return controller;
    });

    weightControllers = List.generate(initialSets, (index) {
      String text = index < weightValues.length ? weightValues[index] : '';
      final controller = TextEditingController(text: text);
      controller.addListener(() {
        widget.weightController.text =
            weightControllers.map((e) => e.text).join(',');
      });
      return controller;
    });

    restTimeControllers = List.generate(initialSets, (index) {
      String text = index < restTimeValues.length ? restTimeValues[index] : '';
      final controller = TextEditingController(text: text);
      controller.addListener(() {
        widget.restTimeController.text =
            restTimeControllers.map((e) => e.text).join(',');
      });
      return controller;
    });

    // Add listeners to the first controllers
    addFirstControllerListener(repsControllers, 'reps');
    addFirstControllerListener(weightControllers, 'weight');
    addFirstControllerListener(restTimeControllers, 'restTime');

    setsController.addListener(() {
      var currentSets = int.tryParse(setsController.text) ?? 0;
      setState(() {
        updateControllersList(
          repsControllers,
          currentSets,
          widget.repsController,
          widget.repsController.text.split(','),
          'reps',
        );
        updateControllersList(
          weightControllers,
          currentSets,
          widget.weightController,
          widget.weightController.text.split(','),
          'weight',
        );
        updateControllersList(
          restTimeControllers,
          currentSets,
          widget.restTimeController,
          widget.restTimeController.text.split(','),
          'restTime',
        );
      });
      widget.updateRepsControllers();
      widget.updateWeightControllers();
      widget.updateRestTimeControllers();
    });

    widget.labelController.addListener(() {
      setState(() {});
    });
  }

  void addFirstControllerListener(
      List<TextEditingController> controllersList, String fieldType) {
    if (controllersList.isNotEmpty) {
      TextEditingController firstController = controllersList[0];

      // Remove previous listener if exists
      if (fieldType == 'reps' && repsFirstControllerListener != null) {
        firstController.removeListener(repsFirstControllerListener!);
      } else if (fieldType == 'weight' &&
          weightFirstControllerListener != null) {
        firstController.removeListener(weightFirstControllerListener!);
      } else if (fieldType == 'restTime' &&
          restTimeFirstControllerListener != null) {
        firstController.removeListener(restTimeFirstControllerListener!);
      }

      void listener() {
        if (isUpdatingControllers) return;
        isUpdatingControllers = true;

        String newText = firstController.text;
        for (int i = 1; i < controllersList.length; i++) {
          if (controllersList[i].text.isEmpty) {
            controllersList[i].text = newText;
          }
        }

        isUpdatingControllers = false;
      }

      // Add listener
      firstController.addListener(listener);

      // Save the listener reference
      if (fieldType == 'reps') {
        repsFirstControllerListener = listener;
      } else if (fieldType == 'weight') {
        weightFirstControllerListener = listener;
      } else if (fieldType == 'restTime') {
        restTimeFirstControllerListener = listener;
      }
    }
  }

  void updateControllersList(
    List<TextEditingController> controllersList,
    int targetLength,
    TextEditingController parentController,
    List<String> existingValues,
    String fieldType,
  ) {
    if (controllersList.length < targetLength) {
      for (int i = controllersList.length; i < targetLength; i++) {
        String text = i < existingValues.length ? existingValues[i] : '';
        final controller = TextEditingController(text: text);
        controller.addListener(() {
          parentController.text = controllersList.map((e) => e.text).join(',');
        });
        controllersList.add(controller);
      }
    } else if (controllersList.length > targetLength) {
      for (int i = controllersList.length - 1; i >= targetLength; i--) {
        controllersList[i].dispose();
        controllersList.removeAt(i);
      }
    }
    parentController.text = controllersList.map((e) => e.text).join(',');

    // Add listener to the first controller
    addFirstControllerListener(controllersList, fieldType);
  }

  @override
  void dispose() {
    for (var controller in repsControllers) {
      controller.dispose();
    }
    for (var controller in weightControllers) {
      controller.dispose();
    }
    for (var controller in restTimeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.5),
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          children: [
            // Header (always visible)
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      widget.labelController.text,
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: theme.colorScheme.error),
                      onPressed: widget.onRemove,
                    ),
                  ),
                ],
              ),
            ),
            // Expandable content
            Visibility(
              visible: isExpanded,
              maintainState: true,
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: TextFormField(
                              controller: widget.setsController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary),
                              decoration: InputDecoration(
                                labelText: 'Séries',
                                labelStyle: TextStyle(
                                    color: theme.colorScheme.onPrimary),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: theme.colorScheme.onPrimary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: theme.colorScheme.onPrimary),
                                ),
                              ),
                              onChanged: (_) {
                                widget.updateRepsControllers();
                                widget.updateWeightControllers();
                                widget.updateRestTimeControllers();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  widget.addError(
                                      "Le nombre de séries est requis");
                                  return "Le nombre de séries est requis";
                                }
                                int? intValue = int.tryParse(value);
                                if (intValue == null || intValue <= 0) {
                                  widget.addError(
                                      "Le nombre de séries doit être un entier positif");
                                  return "Le nombre de séries doit être un entier positif";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: repsControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Série ${index + 1}',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: repsControllers[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Reps',
                                            labelStyle: TextStyle(
                                                color: theme
                                                    .colorScheme.onPrimary),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme
                                                      .colorScheme.onPrimary),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme
                                                      .colorScheme.onPrimary),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              widget.addError(
                                                  "Le nombre de répétitions est requis pour la série ${index + 1}");
                                              return "Le nombre de répétitions est requis";
                                            }
                                            int? intValue = int.tryParse(value);
                                            if (intValue == null ||
                                                intValue <= 0) {
                                              widget.addError(
                                                  "Le nombre de répétitions doit être un entier positif pour la série ${index + 1}");
                                              return "Le nombre de répétitions doit être un entier positif";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: weightControllers[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Poids (kg)',
                                            labelStyle: TextStyle(
                                                color: theme
                                                    .colorScheme.onPrimary),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme
                                                      .colorScheme.onPrimary),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme
                                                      .colorScheme.onPrimary),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              widget.addError(
                                                  "Le poids est requis pour la série ${index + 1}");
                                              return "Le poids est requis";
                                            }
                                            double? doubleValue =
                                                double.tryParse(value);
                                            if (doubleValue == null ||
                                                doubleValue <= 0) {
                                              widget.addError(
                                                  "Le poids doit être un nombre positif pour la série ${index + 1}");
                                              return "Le poids doit être un nombre positif";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              restTimeControllers[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Repos (s)',
                                            labelStyle: TextStyle(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              widget.addError(
                                                  "Le temps de repos est requis pour la série ${index + 1}");
                                              return "Le temps de repos est requis";
                                            }
                                            double? doubleValue =
                                                double.tryParse(value);
                                            if (doubleValue == null ||
                                                doubleValue <= 0) {
                                              widget.addError(
                                                  "Le temps de repos doit être un nombre positif pour la série ${index + 1}");
                                              return "Le temps de repos doit être un nombre positif";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
