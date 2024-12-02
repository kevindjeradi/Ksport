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
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: Colors.black54,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
