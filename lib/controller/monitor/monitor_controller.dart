import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';

class MonitorController extends ControllerMVC {
  factory MonitorController() {
    if (_this == null) _this = MonitorController._();
    return _this;
  }
  static MonitorController _this;
  MonitorController._();

  static MonitorController get con => _this;

  int selectedIndex = 0;
  List<String> monitorNames = [
    'Eugene Lim',
    "Chen Ming Kwok",
    "Satomi Ishihara",
    "Ji Eun Lee",
    "Eric Wilson",
    "David Ponder",
  ];
  List<int> firstWeekPoints = [50, 100, 40, 70, 50, 80];
  List<int> secondWeekPoints = [100, 200, 50, 60, 120, 60];
  List<int> thirdWeekPoints = [40, 60, 80, 40, 100, 75];
  List<int> fourthWeekPoints = [75, 120, 60, 70, 80, 200];
  List<int> weeklyAvgPoints = [66, 120, 58, 60, 88, 104];
  List<int> totalPoints = [265, 480, 230, 240, 350, 415];
  List<Card> monitorCards = [];
}
