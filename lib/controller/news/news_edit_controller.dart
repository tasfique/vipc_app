import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NewsEditController extends ControllerMVC {
  factory NewsEditController() {
    if (_this == null) _this = NewsEditController._();
    return _this;
  }
  static NewsEditController _this;
  NewsEditController._();

  static NewsEditController get con => _this;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
}
