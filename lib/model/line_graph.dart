import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class YearlyPointLineGraph {
  final DateTime time;
  final int point;
  final charts.Color color;

  YearlyPointLineGraph(this.time, this.point, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
