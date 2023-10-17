import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final Image image;
  final String label;
  final Function onTap;

  const WorkoutCard(
      {super.key,
      required this.image,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: image,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
