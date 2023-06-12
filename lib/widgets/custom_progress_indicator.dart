import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomPercentIndicator extends StatelessWidget {
  const CustomPercentIndicator(
      {super.key,
      required this.progress,
      required this.goal,
      required this.color,
      required this.title});

  final dynamic progress;
  final dynamic goal;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
        radius: 100.0,
        lineWidth: 20.0,
        animation: true,
        percent: progress,
        center: Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
        ),
        footer: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "$title progress: ${(progress * goal).round()}/$goal",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: color,
        backgroundColor: Colors.white);
  }
}
