import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/training.dart';

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
  List<Map<String, TextEditingController>> _exerciseControllers = [];

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
        print('\n----------------$exercise\n');
        _exerciseControllers.add({
          'label': TextEditingController(text: exercise['label']),
          'repetitions':
              TextEditingController(text: exercise['repetitions'].toString()),
          'sets': TextEditingController(text: exercise['sets'].toString()),
          'restTime':
              TextEditingController(text: exercise['restTime'].toString()),
        });
      }
    } else {
      _addExercise(); // By default, add one exercise field
    }
  }

  Future<List<Map<String, dynamic>>> _fetchExercises() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/exercises'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  void _showExerciseDialog() async {
    List<Map<String, dynamic>> exercises = await _fetchExercises();

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select an Exercise'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exerciseName =
                      exercises[index]['label'] ?? 'Unknown Exercise';
                  final exerciseId = (exercises[index]['_id'] ?? -1).toString();
                  print(
                      "\n\n----------------------------------------$exerciseId");
                  return ListTile(
                    title: Text(exerciseName),
                    onTap: () {
                      print('Tapped exercise ID: $exerciseId');
                      setState(() {
                        _exerciseControllers.last['label']!.text = exerciseName;
                        _exerciseControllers.last['exerciseId']!.text =
                            exerciseId;
                      });
                      print(
                          'Set exercise ID: ${_exerciseControllers.last['exerciseId']!.text}');
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } else {
      print("if mounted is false !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  void _addExercise() {
    setState(() {
      _exerciseControllers.add({
        'label': TextEditingController(),
        'exerciseId': TextEditingController(),
        'repetitions': TextEditingController(),
        'sets': TextEditingController(),
        'restTime': TextEditingController(),
      });
    });
    _showExerciseDialog();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editingTraining == null
            ? 'Nouvel entrainement'
            : 'Modifier un entrainement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nom de l'entrainement",
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom pour l'entrainement";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'Objectif',
                  prefixIcon: Icon(Icons.flash_on),
                ),
              ),
              const SizedBox(height: 16.0),
              ..._buildExerciseFields(),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Sauvegarder l'entrainement"),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExerciseFields() {
    List<Widget> exerciseFields = [];
    for (int i = 0; i < _exerciseControllers.length; i++) {
      exerciseFields.add(Card(
        elevation: 3.0,
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _exerciseControllers[i]['label'],
                decoration:
                    const InputDecoration(label: Center(child: Text("nom"))),
                readOnly: true,
              ),
              // TextFormField(
              //   controller: _exerciseControllers[i]['exerciseId'],
              //   decoration: const InputDecoration(
              //       label: Center(child: Text("Exercise ID"))),
              //   readOnly: true,
              // ),
              TextFormField(
                controller: _exerciseControllers[i]['repetitions'],
                decoration: const InputDecoration(
                    label: Center(child: Text("repetitions"))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Enter a valid number for repetitions';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _exerciseControllers[i]['sets'],
                decoration:
                    const InputDecoration(label: Center(child: Text("sets"))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Enter a valid number for sets';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _exerciseControllers[i]['restTime'],
                decoration: const InputDecoration(
                    label: Center(child: Text("Rest Time (in seconds)"))),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Enter a valid number for rest time';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: const Text('Remove Exercise'),
                onPressed: () => _removeExercise(i),
              )
            ],
          ),
        ),
      ));
    }
    exerciseFields.add(ElevatedButton(
      onPressed: _addExercise,
      child: const Text('Add New Exercise'),
    ));
    return exerciseFields;
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
          'restTime': int.parse(controller['restTime']!.text),
        });
      }

      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'exercises': exercisesData,
        'goal': _goalController.text,
      };

      if (widget.editingTraining == null) {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/trainings'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );
        if (response.statusCode == 201) {
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          print('Error occurred. HTTP status: ${response.statusCode}');
          print('Response body: ${response.body}');
          // Optionally show an error dialog to the user
        }
      } else {
        final response = await http.put(
          Uri.parse(
              'http://10.0.2.2:3000/trainings/${widget.editingTraining!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          // Handle error
        }
      }
    } else {
      print("form not valid");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    for (var controllerMap in _exerciseControllers) {
      controllerMap.forEach((key, controller) {
        controller.dispose();
      });
    }
    super.dispose();
  }
}
