import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyTrainingsBarChart extends StatelessWidget {
  final List<BarChartGroupData> weeklyTrainingData;
  final Color textColor;

  const WeeklyTrainingsBarChart({
    Key? key,
    required this.weeklyTrainingData,
    required this.textColor,
  }) : super(key: key);

  Widget getWeekTitles(double value, TitleMeta meta) {
    final weekNumber = value.toInt() + 1;
    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final text = Text('Semaine $weekNumber', style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 2) {
      text = value.toInt().toString();
    } else if (value == 4) {
      text = value.toInt().toString();
    } else if (value == 6) {
      text = value.toInt().toString();
    } else {
      value.toInt() % 2 == 0 ? text = value.toInt().toString() : text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Evolution du nombre de séances par semaine",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 16),
            weeklyTrainingData.isEmpty
                ? SizedBox(
                    height: 200,
                    child: Center(
                        child: Text("Bon il s'agirait d'arrêter de forcer",
                            style: theme.textTheme.headlineMedium)),
                  )
                : SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: 8,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 38,
                              getTitlesWidget: getWeekTitles,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: weeklyTrainingData,
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
