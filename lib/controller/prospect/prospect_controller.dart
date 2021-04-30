import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProspectController extends ControllerMVC {
  factory ProspectController() {
    if (_this == null) _this = ProspectController._();
    return _this;
  }
  static ProspectController _this;
  ProspectController._();

  static ProspectController get con => _this;

  int selectedIndex = 0;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
}
