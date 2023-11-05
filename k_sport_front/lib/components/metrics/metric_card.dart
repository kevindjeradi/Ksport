import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final String particle;

  const MetricCard(
      {super.key,
      required this.title,
      required this.value,
      this.particle = ""});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold)),
            Text("$value $particle", style: const TextStyle(fontSize: 24.0)),
          ],
        ),
      ),
    );
  }
}
