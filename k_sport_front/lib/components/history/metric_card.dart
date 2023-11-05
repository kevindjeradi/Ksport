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
    ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Text("$value $particle", style: theme.textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
