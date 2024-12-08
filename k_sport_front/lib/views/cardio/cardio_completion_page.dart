import 'package:flutter/material.dart';
import 'package:k_sport_front/components/cardio/cardio_fields_config.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/services/cardio_service.dart';
import 'package:k_sport_front/views/home.dart';

class CardioCompletionPage extends StatefulWidget {
  final String exerciseName;
  final int duration;

  const CardioCompletionPage({
    Key? key,
    required this.exerciseName,
    required this.duration,
  }) : super(key: key);

  @override
  CardioCompletionPageState createState() => CardioCompletionPageState();
}

String _normalizeDecimalNumber(String value) {
  // Replace comma with period for decimal numbers
  return value.replaceAll(',', '.');
}

class CardioCompletionPageState extends State<CardioCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final _noteController = TextEditingController();
  late final TextEditingController _durationController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _durationController =
        TextEditingController(text: widget.duration.toString());
    final fields = cardioFieldsConfig[widget.exerciseName] ?? {};
    for (var field in fields.keys) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _noteController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveCardioSession() async {
    if (_formKey.currentState!.validate() && !_isSaving) {
      setState(() {
        _isSaving = true;
      });

      try {
        final data = {
          'exerciseName': widget.exerciseName,
          'duration': int.parse(_durationController.text),
          'note': _noteController.text,
          'date': DateTime.now().toIso8601String(),
        };

        for (var entry in _controllers.entries) {
          if (entry.value.text.isNotEmpty) {
            final config = cardioFieldsConfig[widget.exerciseName]![entry.key];
            final normalizedValue = _normalizeDecimalNumber(entry.value.text);
            final value = config?.isDecimal == true
                ? double.parse(normalizedValue)
                : int.parse(normalizedValue);
            data[entry.key] = value;
          }
        }

        final response = await CardioService().saveCardioSession(data);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            showCustomSnackBar(
                context, "Session cardio enregistrée!", SnackBarType.success);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          }
        }
      } catch (e) {
        Log.logger.e('Error saving cardio session: $e');
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
          showCustomSnackBar(
              context,
              "Erreur lors de l'enregistrement de la session",
              SnackBarType.error);
        }
      }
    }
  }

  Widget _buildFormFields() {
    final fields = cardioFieldsConfig[widget.exerciseName] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Durée (minutes)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La durée est requise';
            }
            final duration = int.tryParse(value);
            if (duration == null || duration <= 0) {
              return 'La durée doit être un nombre positif';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        ...fields.entries.map((entry) {
          final fieldName = entry.key;
          final config = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              controller: _controllers[fieldName],
              decoration: InputDecoration(
                labelText: config.label,
                border: const OutlineInputBorder(),
                helperText: config.helperText,
              ),
              keyboardType: config.isDecimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              validator: config.required
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est requis';
                      }
                      if (config.isDecimal) {
                        if (double.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre valide';
                        }
                      } else {
                        if (int.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre entier';
                        }
                      }
                      return null;
                    }
                  : null,
            ),
          );
        }).toList(),
        TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveCardioSession,
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text('Enregistrer'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ReturnAppBar(barTitle: 'Résumé ${widget.exerciseName}'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: _buildFormFields(),
          ),
        ),
      ),
    );
  }
}
