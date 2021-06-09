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

  static LoginController get con => _this;

  GlobalKey<FormState> formKey;
  final employeeIdController = TextEditingController();
  final userPwdController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading;

  Future<void> loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .where('empID', isEqualTo: employeeIdController.text.trim())
            .limit(1)
            .get();

        await auth.signInWithEmailAndPassword(
            email: userData.docs.first['email'],
            password: userPwdController.text.trim());
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).errorColor),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
    employeeIdController.clear();
    userPwdController.clear();
  }
}
