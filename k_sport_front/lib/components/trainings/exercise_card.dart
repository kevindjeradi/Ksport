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
  bool isExpanded = false;
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
      widget.updateRepsControllers();
      widget.updateWeightControllers();
      widget.updateRestTimeControllers();
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
            if (isExpanded) ...[
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
                          decoration: const InputDecoration(
                            labelText: 'Séries',
                          ),
                          onChanged: (_) {
                            widget.updateRepsControllers();
                            widget.updateWeightControllers();
                            widget.updateRestTimeControllers();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              widget.addError("Le nombre de séries est requis");
                              return "Le nombre de séries est requis";
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
                      itemCount: int.tryParse(setsController.text) ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Série ${index + 1}'),
                              SizedBox(
                                width: 70,
                                child: TextFormField(
                                  controller: repsControllers.length > index
                                      ? repsControllers[index]
                                      : TextEditingController(),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Reps',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                child: TextFormField(
                                  controller: weightControllers.length > index
                                      ? weightControllers[index]
                                      : TextEditingController(),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Poids',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                child: TextFormField(
                                  controller: restTimeControllers.length > index
                                      ? restTimeControllers[index]
                                      : TextEditingController(),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Repos',
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
