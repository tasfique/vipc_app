import 'package:mvc_pattern/mvc_pattern.dart';

class SalesController extends ControllerMVC {
  factory SalesController() {
    if (_this == null) _this = SalesController._();
    return _this;
  }
  static SalesController _this;
  SalesController._();

  static SalesController get con => _this;
}
