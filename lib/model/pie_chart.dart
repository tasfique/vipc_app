import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class WeeklyPointPieChart {
  final String week;
  final int point;
  final charts.Color color;

  WeeklyPointPieChart(this.week, this.point, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
