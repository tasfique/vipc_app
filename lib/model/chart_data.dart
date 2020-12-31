import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MonthlyPointBarChart {
  final String month;
  final int point;
  final charts.Color color;

  MonthlyPointBarChart(this.month, this.point, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
