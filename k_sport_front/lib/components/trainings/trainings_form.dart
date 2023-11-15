// trainings_form.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/components/trainings/exercise_fields_list.dart';
import 'package:k_sport_front/components/trainings/training_form_input.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/views/workout_page/muscles_page.dart'; // You should import MusclesPage

class TrainingForm extends StatefulWidget {
  final Training? editingTraining;
  const TrainingForm({Key? key, this.editingTraining}) : super(key: key);

  @override
  TrainingFormState createState() => TrainingFormState();
}

class TrainingFormState extends State<TrainingForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _goalController;
  final List<Map<String, TextEditingController>> _exerciseControllers = [];
  final TrainingService _trainingService = TrainingService();
  final List<String> _formErrors = [];

  void _updateRepsControllers(int exerciseIndex) {
    int currentSets =
        int.tryParse(_exerciseControllers[exerciseIndex]['sets']!.text) ?? 0;
    var repetitions = _exerciseControllers[exerciseIndex]['repetitions']!
        .text
        .split(',')
        .toList();

    // Adjust the repetitions list size to match currentSets
    if (repetitions.length < currentSets) {
      repetitions.addAll(
          List.generate(currentSets - repetitions.length, (index) => '0'));
    } else if (repetitions.length > currentSets) {
      repetitions = repetitions.sublist(0, currentSets);
    }

    // Update the repetitions controller
    _exerciseControllers[exerciseIndex]['repetitions']!.text =
        repetitions.join(',');
  }

  void _updateWeightControllers(int exerciseIndex) {
    int currentSets =
        int.tryParse(_exerciseControllers[exerciseIndex]['sets']!.text) ?? 0;
    var weights =
        _exerciseControllers[exerciseIndex]['weight']!.text.split(',').toList();

    // Adjust the weights list size to match currentSets
    if (weights.length < currentSets) {
      weights
          .addAll(List.generate(currentSets - weights.length, (index) => '0'));
    } else if (weights.length > currentSets) {
      weights = weights.sublist(0, currentSets);
    }

    // Update the weight controller
    _exerciseControllers[exerciseIndex]['weight']!.text = weights.join(',');
  }

  void _updateRestTimeControllers(int exerciseIndex) {
    int currentSets =
        int.tryParse(_exerciseControllers[exerciseIndex]['sets']!.text) ?? 0;
    var restTimes = _exerciseControllers[exerciseIndex]['restTime']!
        .text
        .split(',')
        .toList();

    // Adjust the restTimes list size to match currentSets
    if (restTimes.length < currentSets) {
      restTimes.addAll(
          List.generate(currentSets - restTimes.length, (index) => '0'));
    } else if (restTimes.length > currentSets) {
      restTimes = restTimes.sublist(0, currentSets);
    }

    // Update the restTime controller
    _exerciseControllers[exerciseIndex]['restTime']!.text = restTimes.join(',');
  }

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.editingTraining?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.editingTraining?.description ?? '');
    _goalController =
        TextEditingController(text: widget.editingTraining?.goal ?? '');

    if (widget.editingTraining != null) {
      for (var exercise in widget.editingTraining!.exercises) {
        _exerciseControllers.add({
          'label': TextEditingController(text: exercise['label']),
          'exerciseId': TextEditingController(text: exercise['exerciseId']),
          'sets': TextEditingController(text: exercise['sets'].toString()),
          'repetitions':
              TextEditingController(text: exercise['repetitions'].join(',')),
          'weight': TextEditingController(text: exercise['weight'].join(',')),
          'restTime':
              TextEditingController(text: exercise['restTime'].join(',')),
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    for (var controllerMap in _exerciseControllers) {
      for (var controller in controllerMap.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _navigateToMusclesPage() async {
    final selectedExercise = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MusclesPage(isSelectionMode: true)));
    if (selectedExercise != null) {
      _exerciseControllers.last['label']!.text = selectedExercise.label;
      _exerciseControllers.last['exerciseId']!.text = selectedExercise.id;
    }
  }

  void _addExercise() {
    setState(() {
      _exerciseControllers.add({
        'label': TextEditingController(),
        'exerciseId': TextEditingController(),
        'sets': TextEditingController(),
        'repetitions': TextEditingController(),
        'weight': TextEditingController(),
        'restTime': TextEditingController(),
      });
    });
    _navigateToMusclesPage();
  }

  void _removeExercise(int index) {
    setState(() {
      _exerciseControllers[index]
          .forEach((key, controller) => controller.dispose());
      _exerciseControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ReturnAppBar(
          barTitle: widget.editingTraining == null
              ? 'Nouvel entrainement'
              : 'Modifier un entrainement',
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TrainingFormInput(
                              controller: _nameController,
                              label: "Nom de l'entrainement",
                              icon: Icons.title,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer un nom pour l'entrainement";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12.0),
                            TrainingFormInput(
                                controller: _descriptionController,
                                label: 'Description',
                                icon: Icons.description),
                            const SizedBox(height: 12.0),
                            TrainingFormInput(
                                controller: _goalController,
                                label: 'Objectif',
                                icon: Icons.flash_on),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ExerciseFieldsList(
                        exerciseControllers: _exerciseControllers,
                        addExerciseCallback: _addExercise,
                        removeExerciseCallback: _removeExercise,
                        updateRepsControllers: _updateRepsControllers,
                        updateWeightControllers: _updateWeightControllers,
                        updateRestTimeControllers: _updateRestTimeControllers,
                        addError: _addError,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomElevatedButton(
              onPressed: _submitForm,
              label: "Sauvegarder l'entrainement",
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_exerciseControllers.isEmpty) {
      showCustomSnackBar(
          context, 'Ajoute au moins un exercice', SnackBarType.error);
      return;
    }
    if (_formKey.currentState?.validate() == true) {
      List<Map<String, dynamic>> exercisesData = [];
      for (var controller in _exerciseControllers) {
        List<double> repetitions = controller['repetitions']!
            .text
            .split(',')
            .map((e) => double.tryParse(e) ?? 0.0)
            .toList();
        List<double> weights = controller['weight']!
            .text
            .split(',')
            .map((e) => double.tryParse(e) ?? 0.0)
            .toList();
        List<double> restTimes = controller['restTime']!
            .text
            .split(',')
            .map((e) => double.tryParse(e) ?? 0.0)
            .toList();
        exercisesData.add({
          'label': controller['label']!.text,
          'exerciseId': controller['exerciseId']!.text,
          'sets': int.parse(controller['sets']!.text),
          'repetitions': repetitions,
          'weight': weights,
          'restTime': restTimes,
        });
      }

      Map<String, dynamic> data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'goal': _goalController.text,
        'exercises': exercisesData,
      };

      try {
        final response =
            await _trainingService.saveTraining(data, widget.editingTraining);
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          Log.logger.e(
              'Error saving the training in training_form: ${response.body}');
        }
      } catch (e, s) {
        Log.logger.e(
            'Error saving the training in training_form -> error: $e\nStack trace: $s');
      }
    } else {
      Log.logger.w('Form validation failed in training_form');
      showCustomSnackBar(context, _formErrors.join('\n\n'), SnackBarType.error,
          duration: 5);
    }
    _formErrors.clear();
  }

  void _addError(String error) {
    if (!_formErrors.contains(error)) {
      _formErrors.add(error);
    }
  }
}
