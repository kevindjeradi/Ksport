import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';

class WorkoutCardDetail extends StatelessWidget {
  final String title;
  final Image image;

  const WorkoutCardDetail({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                    )),
                Text(
                  "Exercices pour ${title.toLowerCase()}",
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            Expanded(
              child: image,
            ),
            const SizedBox(height: 8),
            // Text(
            //   description,
            //   style: const TextStyle(fontSize: 16),
            // )
          ],
        ),
      ),
    );
  }
}
