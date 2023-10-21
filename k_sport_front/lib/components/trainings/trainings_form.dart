import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/training.dart';

class TrainingForm extends StatefulWidget {
  final Training? editingTraining;

  const TrainingForm({super.key, this.editingTraining});

  @override
  TrainingFormState createState() => TrainingFormState();
}

class TrainingFormState extends State<TrainingForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _restTimeController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.editingTraining?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.editingTraining?.description ?? '');
    _restTimeController = TextEditingController(
        text: widget.editingTraining?.restTime.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editingTraining == null
            ? 'Nouvel entrainement'
            : 'modifier un entrainement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: "Nom de l'entrainement"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom pour l'entrainement";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _restTimeController,
                decoration: const InputDecoration(
                    labelText: 'Temps de repos en secondes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un temps de repos';
                  }
                  return null;
                },
              ),
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

  void _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      if (widget.editingTraining == null) {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/trainings'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text,
            'description': _descriptionController.text,
            'restTime': int.parse(_restTimeController.text),
          }),
        );
        if (response.statusCode == 201) {
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          // Handle error
        }
      } else {
        final response = await http.put(
          Uri.parse(
              'http://10.0.2.2:3000/trainings/${widget.editingTraining!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text,
            'description': _descriptionController.text,
            'restTime': int.parse(_restTimeController.text),
          }),
        );
        if (response.statusCode == 200) {
          if (mounted) {
            Navigator.pop(context);
          }
        } else {
          // Handle error
        }
      }
    }
  }
}
