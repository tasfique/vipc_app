import 'package:mvc_pattern/mvc_pattern.dart';

class SignupController extends ControllerMVC {
  factory SignupController() {
    if (_this == null) _this = SignupController._();
    return _this;
  }
  static SignupController _this;
  SignupController._();

  static SignupController get con => _this;
}
