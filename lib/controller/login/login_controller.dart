import 'package:mvc_pattern/mvc_pattern.dart';

class LoginController extends ControllerMVC {
  factory LoginController() {
    if (_this == null) _this = LoginController._();
    return _this;
  }
  static LoginController _this;
  LoginController._();

  static LoginController get con => _this;
}
