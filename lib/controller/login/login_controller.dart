import 'package:firebase_auth/firebase_auth.dart';
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

  final formKey = GlobalKey<FormState>();
  final userCodeController = TextEditingController();
  final userPwdController = TextEditingController();
  final auth = FirebaseAuth.instance;

  Future<void> loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState.validate();

    if (isValid) {
      try {
        // UserCredential authResult;
        // authResult =
        await auth.signInWithEmailAndPassword(
            email: userCodeController.text, password: userPwdController.text);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
    }

    // if (userCodeController.text == "taz" && userPwdController.text == "123")
    //   loginSuccess = true;
    // else
    //   loginSuccess = false;

    userCodeController.clear();
    userPwdController.clear();
  }
}
