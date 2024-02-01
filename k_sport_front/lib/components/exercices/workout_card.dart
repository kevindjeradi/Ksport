import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';

class WorkoutCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final Function onTap;

  const WorkoutCard(
      {super.key,
      required this.imageUrl,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomImage(imagePath: imageUrl),
          Positioned(
            bottom: 0,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black54,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
