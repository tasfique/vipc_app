import 'package:mvc_pattern/mvc_pattern.dart';

class SettingsController extends ControllerMVC {
  factory SettingsController() {
    if (_this == null) _this = SettingsController._();
    return _this;
  }
  static SettingsController _this;
  SettingsController._();

  static SettingsController get con => _this;
}
