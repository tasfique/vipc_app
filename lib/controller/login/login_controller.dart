import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';

class LoginController extends ControllerMVC {
  factory LoginController() {
    if (_this == null) _this = LoginController._();
    return _this;
  }

  static LoginController _this;
  LoginController._();
  bool loginSuccess = false;

  static LoginController get con => _this;

  final usernameController = TextEditingController();
  final userPwdController = TextEditingController();

  void LoginUser() {
    if (usernameController.text == "taz" && userPwdController.text == "123")
      loginSuccess = true;
    else
      loginSuccess = false;

    usernameController.clear();
    userPwdController.clear();
  }
}
