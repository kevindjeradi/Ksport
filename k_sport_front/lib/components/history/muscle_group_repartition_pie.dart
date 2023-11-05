import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MuscleGroupRepartitionPie extends StatelessWidget {
  final Map<String, int> muscleGroupProportions;

  const MuscleGroupRepartitionPie({
    Key? key,
    required this.muscleGroupProportions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Color> pieColors = [
      const Color(0xffe57373),
      const Color(0xff81c784),
      const Color(0xff64b5f6),
      const Color(0xffffd54f),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              "Répartition des groupes musculaires travaillés par l'utilisateur",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: muscleGroupProportions.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((mapEntry) {
                    int index = mapEntry.key;
                    MapEntry<String, int> entry = mapEntry.value;
                    return PieChartSectionData(
                      title: entry.key,
                      titleStyle: TextStyle(color: theme.colorScheme.onPrimary),
                      value: entry.value.toDouble(),
                      color: pieColors[index % pieColors.length],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
