// training_form_input
import 'package:flutter/material.dart';

class TrainingFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TrainingFormInput({
    Key? key,
    required this.controller,
    required this.label,
    this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      validator: validator,
    );
  }
}
