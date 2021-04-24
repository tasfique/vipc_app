import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';

class UserEditController extends ControllerMVC {
  factory UserEditController() {
    if (_this == null) _this = UserEditController._();
    return _this;
  }
  static UserEditController _this;
  UserEditController._();

  static UserEditController get con => _this;

  GlobalKey<FormState> formKey;
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final userPwdController = TextEditingController();
  String uid;
  String password;
  String email;
  String fullName;
  String selectedType;
  String type;
  String selectedManager;
  String assignManager;
  bool isAdvisor;
  bool passwordVisible;
  bool isValid;
  bool editSuccess;
  FirebaseApp app2;
  bool isLoading;
  List<String> managers = [];

  Future<void> setToDefault() async {
    uid = null;
    password = null;
    email = null;
    fullName = null;
    selectedType = null;
    selectedManager = null;
    assignManager = null;
    type = null;
    isAdvisor = false;
    passwordVisible = false;
    isValid = false;
    editSuccess = false;
    isLoading = false;
    emailController.clear();
    fullNameController.clear();
    userPwdController.clear();
    await app2.delete();
  }

  Future<void> start(BuildContext context) async {
    passwordVisible = false;
    isLoading = false;
    isValid = false;
    editSuccess = false;
    if (type == 'Manager')
      isAdvisor = false;
    else
      isAdvisor = true;
    try {
      final managerList = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'Manager')
          .get();
      managerList.docs.forEach((result) {
        managers.add(result.data()['fullName']);
      });
      if (type == 'Manager')
        managers.removeWhere((element) => element == fullName);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error, couldn\'s load data.'),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
    app2 = await Firebase.initializeApp(
        name: 'Third', options: Firebase.app().options);
  }

  bool check() {
    if (!(emailController.text.isEmpty || emailController.text == email))
      return true;
    if (!(fullNameController.text.isEmpty ||
        fullNameController.text == fullName)) return true;
    if (!(userPwdController.text.isEmpty || userPwdController.text == password))
      return true;
    if (!(selectedType == null || selectedType == type)) return true;
    return false;
  }

  Future<void> editUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();
    if (isValid) {
      if (check()) {
        setState(() {
          isLoading = true;
        });
        try {
          if (emailController.text != email &&
              (emailController.text.isNotEmpty)) {
            final userData = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: emailController.text)
                .limit(1)
                .get();

            if (userData.docs.length == 0) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'email': emailController.text,
                'fullName': (fullNameController.text.isNotEmpty &&
                        fullNameController.text != fullName)
                    ? fullNameController.text
                    : fullName,
                'type': (selectedType != null && selectedType != type)
                    ? selectedType
                    : type,
                'assignUnder':
                    ((selectedType != null && selectedType == "Manager") ||
                            (selectedType == null && type == "Manager"))
                        ? ""
                        : (selectedManager != null &&
                                selectedManager != assignManager)
                            ? selectedManager
                            : assignManager,
                'password': (userPwdController.text.isNotEmpty &&
                        userPwdController.text != password)
                    ? userPwdController.text
                    : password
              });

              // app2 = await Firebase.initializeApp(
              //     name: 'Third', options: Firebase.app().options);

              await FirebaseAuth.instanceFor(app: app2)
                  .signInWithEmailAndPassword(email: email, password: password)
                  .then((value) {
                value.user.updateEmail(emailController.text);
              });

              if ((userPwdController.text.isNotEmpty &&
                  userPwdController.text != password)) {
                await FirebaseAuth.instanceFor(app: app2)
                    .signInWithEmailAndPassword(
                        email: emailController.text, password: password)
                    .then((value) {
                  value.user.updatePassword(userPwdController.text);
                });
              }

              // await app2.delete();

              setState(() {
                editSuccess = true;
              });
            } else {
              setState(() {
                editSuccess = false;
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Email address already exists. Please enter another email address.'),
                    backgroundColor: Theme.of(context).errorColor),
              );
            }
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({
              'email': email,
              'fullName': (fullNameController.text.isNotEmpty &&
                      fullNameController.text != fullName)
                  ? fullNameController.text
                  : fullName,
              'type': (selectedType != null && selectedType != type)
                  ? selectedType
                  : type,
              'assignUnder':
                  ((selectedType != null && selectedType == "Manager") ||
                          (selectedType == null && type == "Manager"))
                      ? ""
                      : (selectedManager != null &&
                              selectedManager != assignManager)
                          ? selectedManager
                          : assignManager,
              'password': (userPwdController.text.isNotEmpty &&
                      userPwdController.text != password)
                  ? userPwdController.text
                  : password
            });

            if (!(userPwdController.text.isEmpty ||
                userPwdController.text == password)) {
              // app2 = await Firebase.initializeApp(
              //     name: 'Third', options: Firebase.app().options);

              await FirebaseAuth.instanceFor(app: app2)
                  .signInWithEmailAndPassword(email: email, password: password)
                  .then((value) {
                value.user.updatePassword(userPwdController.text);
              });

              // await app2.delete();
            }

            setState(() {
              editSuccess = true;
            });
          }
        } catch (error) {
          setState(() {
            editSuccess = false;
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(error.message),
                backgroundColor: Theme.of(context).errorColor),
          );
        }
      } else {
        setState(() {
          editSuccess = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please enter updated value for user.'),
            backgroundColor: Theme.of(context).errorColor));
      }
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    try {
      //  app2 = await Firebase.initializeApp(
      //     name: 'Third', options: Firebase.app().options);

      await FirebaseAuth.instanceFor(app: app2)
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        value.user.delete();
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(err.message),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
