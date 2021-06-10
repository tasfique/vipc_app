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

        final mail =
            await FirebaseFirestore.instance.collection('email').limit(1).get();
        final managementMail = await FirebaseFirestore.instance
            .collection('managementEmail')
            .limit(1)
            .get();

        String managementEmail = managementMail.docs.first.data()['email'];
        String userN = mail.docs.first.data()['userMail'];
        String passW = mail.docs.first.data()['passwordMail'];

        final smtpServer = gmail(userN, passW);

        final message = Message()
          ..from = Address(userN, 'VIPC')
          ..recipients.add(email)
          ..subject = 'New Password for VIPC App'
          ..html = "<h2>Greetings,</h2><P>A request has been received to change the password for your VIPC Group account." +
              "</P><p>Your new Password: ${userPwdController.text}</p><p>If you did not initiate this request, please contact" +
              " us immediately at $managementEmail .</p><br/><p>Thank you,</p><p>Admin</p>";

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
