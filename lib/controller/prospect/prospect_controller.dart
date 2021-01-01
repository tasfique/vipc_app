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
}
