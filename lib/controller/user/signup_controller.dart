import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  bool isValid;
  bool signUpSuccess;
  bool isLoading;
  bool isAdvisor;
  bool passwordVisible;
  bool passwordVisible2;

  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'create_User');
  final empIdController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final userPwdController = TextEditingController();
  final userPwdController2 = TextEditingController();
  List<String> managers;
  String selectedType;
  String selectedManager;

  void clean(BuildContext context) async {
    passwordVisible = false;
    passwordVisible2 = false;
    isLoading = false;
    isValid = false;
    signUpSuccess = false;
    isAdvisor = false;
    empIdController.clear();
    emailController.clear();
    fullNameController.clear();
    userPwdController.clear();
    userPwdController2.clear();
    selectedType = null;
    selectedManager = null;
    try {
      final managerList = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'Manager')
          .get();
      managerList.docs.forEach((result) {
        managers.add(result.data()['fullName']);
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error, couldn\'s load data.'),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> signupUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .where('empID', isEqualTo: empIdController.text)
            .limit(1)
            .get();

        if (userData.docs.length == 0) {
          FirebaseApp app = await Firebase.initializeApp(
              name: 'Secondary', options: Firebase.app().options);

          UserCredential userCredential =
              await FirebaseAuth.instanceFor(app: app)
                  .createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: userPwdController.text.trim());

          await app.delete();

          if (!isAdvisor || managers.isEmpty) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user.uid)
                .set({
              'empID': empIdController.text.trim(),
              'email': emailController.text.trim(),
              'fullName': fullNameController.text.trim(),
              'type': selectedType,
              'assignUnder': '',
              'password': userPwdController.text.trim()
            });
            setState(() {
              isLoading = false;

              signUpSuccess = true;
            });
          } else if (isAdvisor) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user.uid)
                .set({
              'empID': empIdController.text.trim(),
              'email': emailController.text.trim(),
              'fullName': fullNameController.text.trim(),
              'type': selectedType,
              'assignUnder': selectedManager,
              'password': userPwdController.text.trim()
            });
            setState(() {
              isLoading = false;
              signUpSuccess = true;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Employee ID already exists.'),
                backgroundColor: Theme.of(context).errorColor),
          );
          setState(() {
            signUpSuccess = false;
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          signUpSuccess = false;
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