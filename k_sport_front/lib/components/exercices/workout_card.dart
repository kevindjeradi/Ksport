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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          image,
          Positioned(
            bottom: 0,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors
                    .black54, // This adds a slight background for better readability.
                fontSize: 16, // Adjust the font size as necessary.
              ),
            ),
          ),
        ],
      ),
    );
  }
}
