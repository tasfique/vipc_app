import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SignupController extends ControllerMVC {
  factory SignupController() {
    if (_this == null) _this = SignupController._();
    return _this;
  }
  static SignupController _this;
  SignupController._();

  static SignupController get con => _this;

  final formKey = GlobalKey<FormState>();
  final empIdController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final userPwdController = TextEditingController();

  String selectedType;
  String selectedManager;
}
