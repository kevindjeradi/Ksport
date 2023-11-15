// exercise_history.dart
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/history/bar_charts/custom_bar_chart.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ExerciseHistory extends StatelessWidget {
  final String exerciseLabel;

  const ExerciseHistory({Key? key, required this.exerciseLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final completedTrainings = userProvider.completedTrainings ?? [];

    // Lists for storing aggregated data for charts
    List<int> totalWeightsList = [];
    List<int> totalRepsList = [];
    List<int> totalRestTimesList = [];

    // Aggregate data from exercises
    for (var completedTraining in completedTrainings) {
      final exercises = completedTraining.exercises
          .where((exercise) => exercise.label == exerciseLabel)
          .toList();

      if (exercises.isNotEmpty) {
        int totalWeight = 0;
        int totalReps = 0;
        int totalRestTime = 0;

        for (var exercise in exercises) {
          totalWeight += exercise.weight.fold(0, (sum, item) => sum + item);
          totalReps += exercise.repetitions.fold(0, (sum, item) => sum + item);
          totalRestTime += exercise.restTime.fold(0, (sum, item) => sum + item);
        }

        // Add to the lists
        totalWeightsList.add(totalWeight);
        totalRepsList.add(totalReps);
        totalRestTimesList.add(totalRestTime);
      }
    }

    // Prepare bar chart data for each chart
    List<BarChartGroupData> weightBarData = _prepareBarData(totalWeightsList);
    List<BarChartGroupData> setsBarData = _prepareBarData(totalRepsList);
    List<BarChartGroupData> restTimeBarData =
        _prepareBarData(totalRestTimesList);

    return Scaffold(
      appBar: ReturnAppBar(
          barTitle: "Datas sur $exerciseLabel",
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomBarChart(
              barData: weightBarData,
              chartTitle: 'Evolution du poids soulevé',
              textColor: theme.colorScheme.onSecondary,
            ),
            _buildLineChart(
              _prepareLineChartData(totalWeightsList),
              'Evolution du poids soulevé',
              theme.colorScheme.onSecondary,
            ),
            CustomBarChart(
              barData: setsBarData,
              chartTitle: 'Evolution du nombre de repetitions',
              textColor: theme.colorScheme.onSecondary,
            ),
            _buildLineChart(
              _prepareLineChartData(totalRepsList),
              'Evolution du nombre de repetitions',
              theme.colorScheme.onSecondary,
            ),
            CustomBarChart(
              barData: restTimeBarData,
              chartTitle: 'Evolution du temps de repos',
              textColor: theme.colorScheme.onSecondary,
            ),
            _buildLineChart(
              _prepareLineChartData(totalRestTimesList),
              'Evolution du temps de repos',
              theme.colorScheme.onSecondary,
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _prepareBarData(List<int> dataList) {
    return dataList.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}

List<FlSpot> _prepareLineChartData(List<int> dataList) {
  return dataList
      .asMap()
      .entries
      .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
      .toList();
}

Widget _buildLineChart(List<FlSpot> spots, String chartTitle, Color textColor) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              chartTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Color(0xff37434d),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border:
                        Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  minY: 0,
                  maxY:
                      spots.map((spot) => spot.y).reduce(max).toDouble() * 1.2,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueAccent,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          return LineTooltipItem(
                            '${touchedSpot.y.toInt()}',
                            TextStyle(color: textColor),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
