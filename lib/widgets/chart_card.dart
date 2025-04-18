import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({super.key, required this.spots});

  final List<FlSpot> spots;

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 300.0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(.3),
            highlightColor: Colors.grey[50]!.withOpacity(.7),
            child: Container(
              color: Colors.black.withOpacity(.2),
            ),
          ),
        ),
      );
    }
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final padding = 10.0;

    return  SizedBox(
      height: 300,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: minY - padding < 0 ? 0 : minY - padding,
          maxY: maxY + padding,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.white.withOpacity(.05),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 25,
                getTitlesWidget: (value, _) {
                  const daysOfWeek = [ 'Sat','Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                  int index = value.toInt();
                  if (index < 0 || index >= daysOfWeek.length) {
                    return const SizedBox.shrink(); // Hide invalid labels
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      daysOfWeek[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),

            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false, border: Border.all(color: Colors.white12)),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: const Color(0xFFafc170),
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFafc170).withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              spots: spots,
            ),
          ],
        ),
      ),
    );
  }
}
