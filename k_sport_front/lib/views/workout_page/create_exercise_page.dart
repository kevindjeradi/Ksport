// create_exercise_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/models/exercise.dart';
import 'package:k_sport_front/services/api.dart';

class CreateExercisePage extends StatefulWidget {
  final String muscleLabel;

  const CreateExercisePage({super.key, required this.muscleLabel});

  @override
  CreateExercisePageState createState() => CreateExercisePageState();
}

class CreateExercisePageState extends State<CreateExercisePage> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _labelController = TextEditingController();
  final _detailDescriptionController = TextEditingController();
  bool _isLoading = false;
  String? _imageUrlPreview;
  bool _urlIsImage = false;

  @override
  void dispose() {
    _imageUrlController.dispose();
    _labelController.dispose();
    _detailDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String imageUrl = _imageUrlController.text;
      Uri? uri = Uri.tryParse(imageUrl);

      if (uri == null || !uri.hasAbsolutePath || uri.host.isEmpty) {
        if (mounted) {
          showCustomSnackBar(
              context, "L'URL de l'image n'est pas valide", SnackBarType.error);
          return;
        }
      }
      if (!_urlIsImage) {
        if (mounted) {
          showCustomSnackBar(
              context, "L'URL n'est pas une image", SnackBarType.error);
          return;
        }
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final Exercise exercise = Exercise(
          id: DateTime.now().toString(),
          imageUrl: _imageUrlController.text,
          label: _labelController.text,
          detailTitle: _labelController.text,
          detailDescription: _detailDescriptionController.text,
          muscleLabel: widget.muscleLabel,
        );
        await Api().addExercise(exercise);
        if (mounted) {
          showCustomSnackBar(
              context, 'Exercice créé avec succès!', SnackBarType.success);
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          showCustomSnackBar(
              context, 'L\'exercice n\'a pas pu être créé', SnackBarType.error);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _updatePreview() {
    setState(() {
      _imageUrlPreview = _imageUrlController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ReturnAppBar(
        barTitle: 'Ajouter un exercice',
        bgColor: theme.colorScheme.primary,
        color: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text("Muscle: ${widget.muscleLabel}",
                    style: theme.textTheme.displaySmall),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: 'Exercice',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label_outline,
                        color: theme.colorScheme.primary),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un nom d\'exercice';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _detailDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label_outline,
                        color: theme.colorScheme.primary),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _imageUrlController,
                  onChanged: (_) => _updatePreview(),
                  decoration: InputDecoration(
                    labelText: 'lien de l\'image',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image_outlined,
                        color: theme.colorScheme.primary),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'L\'url de l\'image est obligatoire';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                LayoutBuilder(builder: (context, constraints) {
                  double imageWidth = constraints.maxWidth;
                  double imageHeight = imageWidth * 0.75;

                  return _imageUrlPreview != null && _imageUrlPreview != ""
                      ? CustomImage(
                          imagePath: _imageUrlPreview!,
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              _urlIsImage = true;
                              return child;
                            } else {
                              return const Center(child: CustomLoader());
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            _urlIsImage = false;
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const CustomLoader(),
                                  const SizedBox(height: 20),
                                  Text(
                                    'En attente d\'une url d\'image valide',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink();
                }),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  onPressed: _submitForm,
                  label: 'Ajouter cet exercice',
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                if (_isLoading) const CustomLoader(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
