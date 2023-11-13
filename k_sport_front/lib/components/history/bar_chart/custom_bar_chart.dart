import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatelessWidget {
  final List<BarChartGroupData> barData;
  final String chartTitle;
  final Color textColor;

  const CustomBarChart({
    Key? key,
    required this.barData,
    required this.chartTitle,
    required this.textColor,
  }) : super(key: key);

  // Function to generate side titles for the X-axis
  Widget bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    final style = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = index < barData.length ? '${index + 1}' : '';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
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
                chartTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            barData.isEmpty
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
                              getTitlesWidget: bottomTitles,
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 28,
                              interval: 1,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barData,
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
