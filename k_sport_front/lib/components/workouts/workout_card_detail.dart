import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';

class WorkoutCardDetail extends StatelessWidget {
  final String title;
  final String muscleLabel;
  final Image image;
  final String description;

  const WorkoutCardDetail({
    Key? key,
    required this.title,
    required this.muscleLabel,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReturnAppBar(
          barTitle: "${title.toLowerCase()} pour $muscleLabel",
          bgColor: Colors.blue,
          color: Colors.white,
          elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: image,
                ),
              ),
            ),
            const SizedBox(height: 16), // Increased the space a little bit.
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
