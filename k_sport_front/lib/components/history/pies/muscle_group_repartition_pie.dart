import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MuscleGroupRepartitionPie extends StatelessWidget {
  final Map<String, int> muscleGroupProportions;
  final String period;

  const MuscleGroupRepartitionPie(
      {Key? key, required this.muscleGroupProportions, this.period = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Color> pieColors = [
      const Color(0xffe57373),
      const Color(0xff81c784),
      const Color(0xff64b5f6),
      const Color(0xffffd54f),
      const Color(0xffba68c8),
    ];

    final total = muscleGroupProportions.values.fold(0, (a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: muscleGroupProportions.isEmpty
                ? Center(
                    child: Text("Faut s'entraîner déjà",
                        style: theme.textTheme.headlineMedium))
                : PieChart(
                    PieChartData(
                      sections: muscleGroupProportions.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((mapEntry) {
                        int index = mapEntry.key;
                        MapEntry<String, int> entry = mapEntry.value;
                        final percentage =
                            ((entry.value / total) * 100).toStringAsFixed(1);
                        return PieChartSectionData(
                          title: '$percentage%',
                          titleStyle:
                              TextStyle(color: theme.colorScheme.onPrimary),
                          value: entry.value.toDouble(),
                          color: pieColors[index % pieColors.length],
                        );
                      }).toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 4.0,
            children: muscleGroupProportions.keys
                .toList()
                .asMap()
                .entries
                .map((mapEntry) {
              int index = mapEntry.key;
              String key = mapEntry.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: pieColors[index % pieColors.length],
                  ),
                  const SizedBox(width: 4),
                  Text(key, style: theme.textTheme.bodyMedium),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
