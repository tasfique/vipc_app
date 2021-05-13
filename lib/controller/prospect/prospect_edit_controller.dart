import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProspectEditController extends ControllerMVC {
  factory ProspectEditController() {
    if (_this == null) _this = ProspectEditController._();
    return _this;
  }
  static ProspectEditController _this;
  ProspectEditController._();

  static ProspectEditController get con => _this;
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'prospect_edit');
  int selectedIndex = 0;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
}
