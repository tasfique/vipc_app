import 'package:mvc_pattern/mvc_pattern.dart';

class ForgotPasswordController extends ControllerMVC {
  factory ForgotPasswordController() {
    if (_this == null) _this = ForgotPasswordController._();
    return _this;
  }
  static ForgotPasswordController _this;
  ForgotPasswordController._();

  static ForgotPasswordController get con => _this;
}
