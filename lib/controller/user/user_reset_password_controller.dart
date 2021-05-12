import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class UserResetPasswordController extends ControllerMVC {
  factory UserResetPasswordController() {
    if (_this == null) _this = UserResetPasswordController._();
    return _this;
  }
  static UserResetPasswordController _this;
  UserResetPasswordController._();

  static UserResetPasswordController get con => _this;

  GlobalKey<FormState> formKey;
  final userPwdController = TextEditingController();
  final userPwdController2 = TextEditingController();
  String uid;
  String email;
  String password;
  bool passwordVisible;
  bool passwordVisible2;
  bool isLoading;
  bool isValid;
  bool resetSuccess;
  FirebaseApp app;

  Future<void> setToDefault() async {
    uid = null;
    email = null;
    password = null;
    passwordVisible = false;
    passwordVisible2 = false;
    isValid = false;
    resetSuccess = false;
    isLoading = false;
    userPwdController.clear();
    userPwdController2.clear();
    // await app.delete();
  }

  Future<void> start() async {
    passwordVisible = false;
    passwordVisible2 = false;
    isLoading = false;
    isValid = false;
    resetSuccess = false;
    userPwdController.clear();
    userPwdController2.clear();
    app = await Firebase.initializeApp(
        name: 'Fourth', options: Firebase.app().options);
  }

  Future<void> resetPasswordUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'password': userPwdController.text,
          'requestChangingPassword': '0'
        });

        await FirebaseAuth.instanceFor(app: app)
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          value.user.updatePassword(userPwdController.text);
        });

        String userN = 'j18026306@student.newinti.edu.my';
        String passW = 'A99QratAcXg';

        final smtpServer = gmail(userN, passW);

        final message = Message()
          ..from = Address(userN, 'VIPC')
          ..recipients.add(email)
          ..subject = 'New Password for VIPC App'
          ..html =
              "<h1>Hey there,</h1>\n<p>Your new VIPC password: ${userPwdController.text}</p>\n<p>Best Regards,</p>";

        await send(message, smtpServer);

        setState(() {
          isLoading = false;
          resetSuccess = true;
        });
      } catch (error) {
        setState(() {
          resetSuccess = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
    }
  }
}
