// trainings_form.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/components/trainings/exercise_fields_list.dart';
import 'package:k_sport_front/components/trainings/training_form_input.dart';
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
          'repetitions':
              TextEditingController(text: exercise['repetitions'].toString()),
          'sets': TextEditingController(text: exercise['sets'].toString()),
          'weight': TextEditingController(text: exercise['weight'].toString()),
          'restTime':
              TextEditingController(text: exercise['restTime'].toString()),
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addExercise(); // By default, add one exercise field
      });
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
        'repetitions': TextEditingController(),
        'sets': TextEditingController(),
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
    if (_formKey.currentState?.validate() == true) {
      List<Map<String, dynamic>> exercisesData = [];
      for (var controller in _exerciseControllers) {
        exercisesData.add({
          'label': controller['label']!.text,
          'exerciseId': controller['exerciseId']!.text,
          'repetitions': int.parse(controller['repetitions']!.text),
          'sets': int.parse(controller['sets']!.text),
          'weight': double.parse(controller['weight']!.text),
          'restTime': int.parse(controller['restTime']!.text),
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
          print('Error saving the training: ${response.body}');
        }
      } catch (e) {
        print('Error saving the training: $e');
      }
    }
  }
}
