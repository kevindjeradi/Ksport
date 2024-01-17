import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ExerciseLineChart extends StatelessWidget {
  final List<int> dataList;
  final String chartTitle;
  final Color textColor;

  const ExerciseLineChart({
    Key? key,
    required this.dataList,
    required this.chartTitle,
    required this.textColor,
  }) : super(key: key);

  List<FlSpot> _prepareLineChartData(List<int> dataList) {
    return dataList
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = _prepareLineChartData(dataList);
    double maxY;
    if (spots.isNotEmpty) {
      maxY = spots.map((spot) => spot.y).reduce(max).toDouble() * 1.2;
    } else {
      maxY = 1;
    }
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
                    maxY: maxY,
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
}
