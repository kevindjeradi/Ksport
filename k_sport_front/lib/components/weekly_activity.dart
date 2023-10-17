import 'package:flutter/material.dart';

class WeeklyActivity extends StatelessWidget {
  final List<bool> progress;

  const WeeklyActivity({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress.length != 7) {
      throw ArgumentError(
          'The progress list should contain exactly 7 values for each day of the week.');
    }

    return Column(
      children: [
        const Text("La semaine dernière", style: TextStyle(fontSize: 20)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 20,
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: progress[index]
                                ? Colors.purple
                                : Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ['L', 'M', 'M', 'J', 'V', 'S', 'D'][index],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add navigation or detailed view functionality here
                },
                child: const Text("Voir les détails >"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
