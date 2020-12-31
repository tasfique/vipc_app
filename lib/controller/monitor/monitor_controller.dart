import 'package:mvc_pattern/mvc_pattern.dart';

class MonitorController extends ControllerMVC {
  factory MonitorController() {
    if (_this == null) _this = MonitorController._();
    return _this;
  }
  static MonitorController _this;
  MonitorController._();

  static MonitorController get con => _this;
}
