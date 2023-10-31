import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/services/api.dart';

class CreateMusclePage extends StatefulWidget {
  const CreateMusclePage({super.key});

  @override
  CreateMusclePageState createState() => CreateMusclePageState();
}

class CreateMusclePageState extends State<CreateMusclePage> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _labelController = TextEditingController();
  bool _isLoading = false;
  String? _imageUrlPreview;
  bool _UrlIsImage = false;

  @override
  void dispose() {
    _imageUrlController.dispose();
    _labelController.dispose();
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
      if (!_UrlIsImage) {
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
        final muscle = Muscle(
          id: DateTime.now().toString(),
          imageUrl: _imageUrlController.text,
          label: _labelController.text,
          detailTitle: _labelController.text,
        );

        await Api.addMuscle(muscle);
        if (mounted) {
          showCustomSnackBar(
              context, "Le muscle a bien été ajouté!", SnackBarType.success);
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (mounted) {
          showCustomSnackBar(context, "Le muscle n'a pas été ajouté, réessayez",
              SnackBarType.error);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
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
        barTitle: 'Ajouter un muscle',
        bgColor: theme.colorScheme.primary,
        color: theme.colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _labelController,
                        decoration: InputDecoration(
                          labelText: 'Nom du muscle',
                          border: const OutlineInputBorder(),
                          prefixIcon: Icon(Icons.label_outline,
                              color: theme.colorScheme.primary),
                          labelStyle:
                              TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le nom du muscle est obligatoire';
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
                          labelStyle:
                              TextStyle(color: theme.colorScheme.onSurface),
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
                    ],
                  ),
                ),
                LayoutBuilder(builder: (context, constraints) {
                  double imageWidth = constraints.maxWidth;
                  double imageHeight = imageWidth * 0.75;

                  return _imageUrlPreview != null && _imageUrlPreview != ""
                      ? Image.network(
                          _imageUrlPreview!,
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              _UrlIsImage = true;
                              return child;
                            } else {
                              return const Center(child: CustomLoader());
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            _UrlIsImage = false;
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
                _isLoading
                    ? const CustomLoader()
                    : CustomElevatedButton(
                        onPressed: _submitForm,
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        label: 'Ajouter ce muscle',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
