import 'package:cloud_firestore/cloud_firestore.dart';
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

  // bool loginSuccess = false;

  static LoginController get con => _this;

  final formKey = GlobalKey<FormState>();
  final employeeIdController = TextEditingController();
  final userPwdController = TextEditingController();
  final auth = FirebaseAuth.instance;

  Future<void> loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState.validate();

    if (isValid) {
      try {
        print('display ${employeeIdController.text}');
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .where('empID', isEqualTo: employeeIdController.text)
            .limit(1)
            .get();

        // print(val['empID']);
        // print(val.docs.data()['email']);

        // UserCredential authResult;
        // authResult =
        await auth.signInWithEmailAndPassword(
            email: userData.docs.first['email'],
            password: userPwdController.text);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
    }

    // if (employeeIdController.text == "taz" && userPwdController.text == "123")
    //   loginSuccess = true;
    // else
    //   loginSuccess = false;

    employeeIdController.clear();
    userPwdController.clear();
  }
}
