// exercise_card.dart
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
  late TextEditingController setsController;
  late List<TextEditingController> repsControllers;
  late List<TextEditingController> weightControllers;
  late List<TextEditingController> restTimeControllers;

  @override
  void initState() {
    super.initState();
    setsController = widget.setsController;
    repsControllers = List.generate(
      widget.repsController.text.split(',').length,
      (index) => TextEditingController(
          text: widget.repsController.text.split(',')[index]),
    );

    weightControllers = List.generate(
      widget.weightController.text.split(',').length,
      (index) => TextEditingController(
          text: widget.weightController.text.split(',')[index]),
    );

    restTimeControllers = List.generate(
      widget.restTimeController.text.split(',').length,
      (index) => TextEditingController(
          text: widget.restTimeController.text.split(',')[index]),
    );

    // Update the parent reps controller when a reps controller changes
    for (var controller in repsControllers) {
      controller.addListener(() {
        widget.repsController.text =
            repsControllers.map((e) => e.text).join(',');
      });
    }

    // Update the parent weight controller when a weight controller changes
    for (var controller in weightControllers) {
      controller.addListener(() {
        widget.weightController.text =
            weightControllers.map((e) => e.text).join(',');
      });
    }

// Update the parent restTime controller when a restTime controller changes
    for (var controller in restTimeControllers) {
      controller.addListener(() {
        widget.restTimeController.text =
            restTimeControllers.map((e) => e.text).join(',');
      });
    }

    setsController.addListener(() {
      var currentSets = int.tryParse(setsController.text) ?? 0;
      if (currentSets != repsControllers.length) {
        setState(() {
          if (repsControllers.length < currentSets) {
            repsControllers.addAll(List.generate(
                currentSets - repsControllers.length,
                (index) => TextEditingController(text: '0')
                  ..addListener(() {
                    widget.repsController.text =
                        repsControllers.map((e) => e.text).join(',');
                  })));
          } else if (repsControllers.length > currentSets) {
            repsControllers
                .sublist(currentSets)
                .forEach((controller) => controller.dispose());
            repsControllers = repsControllers.sublist(0, currentSets);
          }
          widget.repsController.text =
              repsControllers.map((e) => e.text).join(',');
        });
      }
      if (currentSets != weightControllers.length) {
        setState(() {
          if (weightControllers.length < currentSets) {
            weightControllers.addAll(List.generate(
                currentSets - weightControllers.length,
                (index) => TextEditingController(text: '0')
                  ..addListener(() {
                    widget.weightController.text =
                        weightControllers.map((e) => e.text).join(',');
                  })));
          } else if (weightControllers.length > currentSets) {
            weightControllers
                .sublist(currentSets)
                .forEach((controller) => controller.dispose());
            weightControllers = weightControllers.sublist(0, currentSets);
          }
          widget.weightController.text =
              weightControllers.map((e) => e.text).join(',');
        });
      }
      if (currentSets != restTimeControllers.length) {
        setState(() {
          if (restTimeControllers.length < currentSets) {
            restTimeControllers.addAll(List.generate(
                currentSets - restTimeControllers.length,
                (index) => TextEditingController(text: '0')
                  ..addListener(() {
                    widget.restTimeController.text =
                        restTimeControllers.map((e) => e.text).join(',');
                  })));
          } else if (restTimeControllers.length > currentSets) {
            restTimeControllers
                .sublist(currentSets)
                .forEach((controller) => controller.dispose());
            restTimeControllers = restTimeControllers.sublist(0, currentSets);
          }
          widget.restTimeController.text =
              restTimeControllers.map((e) => e.text).join(',');
        });
      }
    });
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
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  style: theme.textTheme.headlineSmall,
                  controller: widget.labelController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Nom de l'exercice",
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12.0),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: widget.setsController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        labelText: 'Séries',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          String error =
                              'Entrez le nombre de séries pour ${widget.labelController.text}';
                          widget.addError(error);
                          return error;
                        }
                        if (int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          String error =
                              'Entrez un nombre valide de séries pour ${widget.labelController.text}';
                          widget.addError(error);
                          return error;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: List.generate(repsControllers.length, (index) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          controller: repsControllers[index],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            labelText: 'Reps série ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              String error =
                                  "Entrez le nombre de répétitions pour la serie ${index + 1}";
                              widget.addError(error);
                              return error;
                            }
                            if (int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              String error =
                                  "Entrez un nombre valide de répétitions pour la serie ${index + 1}";
                              widget.addError(error);
                              return error;
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                Row(
                  children: List.generate(restTimeControllers.length, (index) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          controller: restTimeControllers[index],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            labelText: 'Repos ${index + 1} (sec)',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              String error =
                                  'Entrez un temps de repos pour la serie ${index + 1}';
                              widget.addError(error);
                              return error;
                            }
                            if (double.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              String error =
                                  'Entrez un temps de repos valide pour la serie ${index + 1}';
                              widget.addError(error);
                              return error;
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                Row(
                  children: List.generate(weightControllers.length, (index) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          controller: weightControllers[index],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            labelText: 'Poids ${index + 1} (kg)',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              String error =
                                  'Entrez le poids pour la serie ${index + 1}';
                              widget.addError(error);
                              return error;
                            }
                            if (double.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              String error =
                                  'Entrez un poids valide pour la serie ${index + 1}';
                              widget.addError(error);
                              return error;
                            }
                            return null;
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: widget.onRemove,
              tooltip: 'Supprimer',
            ),
          ),
        ],
      ),
    );
  }
}
