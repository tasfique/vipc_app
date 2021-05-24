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
  // final userPwdController = TextEditingController();
  String uid;
  String password;
  String email;
  String fullName;
  String selectedType;
  String type;
  String selectedManager;
  String assignManager;
  bool isAdvisor;
  // bool passwordVisible;
  bool isValid;
  bool editSuccess;
  FirebaseApp app;
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
    // passwordVisible = false;
    isValid = false;
    editSuccess = false;
    isLoading = false;
    emailController.clear();
    fullNameController.clear();
    // userPwdController.clear();
    // await app.delete();
  }

  Future<void> start(BuildContext context) async {
    emailController.clear();
    fullNameController.clear();
    // userPwdController.clear();
    // passwordVisible = false;
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
    app = await Firebase.initializeApp(
        name: 'Third', options: Firebase.app().options);
  }

  bool check() {
    if (!(emailController.text.isEmpty || emailController.text == email))
      return true;
    if (!(fullNameController.text.isEmpty ||
        fullNameController.text == fullName)) return true;
    // if (!(userPwdController.text.isEmpty || userPwdController.text == password))
    //   return true;
    if (!(selectedType == null || selectedType == type)) return true;
    if (!(selectedManager == null || selectedManager == assignManager))
      return true;
    return false;
  }

  setSearchParam(String searchString) {
    List<String> caseSearchList = [];
    String temp = "", temp2 = '';
    bool checkValue = false;
    for (int i = 0; i < searchString.length; i++) {
      if (searchString[i] == " ") {
        if (!checkValue) {
          temp = temp2;
          checkValue = true;
        }
        temp2 = "";
      } else {
        temp2 = temp2 + searchString[i];
        caseSearchList.add(temp2.toLowerCase());
      }
      if (checkValue) {
        temp = temp + searchString[i];
        caseSearchList.add(temp.toLowerCase());
      }
    }
    return caseSearchList;
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
          List<String> caseSearchListSaveToFireBase;
          if (fullNameController.text.isNotEmpty &&
              fullNameController.text != fullName)
            caseSearchListSaveToFireBase =
                setSearchParam(fullNameController.text.trim());
          else
            caseSearchListSaveToFireBase = setSearchParam(fullName);

          if (emailController.text != email &&
              (emailController.text.isNotEmpty)) {
            final userData = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: emailController.text)
                .limit(1)
                .get();

            if (userData.docs.length == 0) {
              if (selectedType != null &&
                  selectedType != type &&
                  selectedType == 'Manager') {
                print('no email, advisor to manager');
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'type': 'Manager', 'assignUnder': ''}).then(
                        (_) async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .where('fullName', isEqualTo: assignManager)
                      .limit(1)
                      .get()
                      .then((managerId) async {
                    await FirebaseFirestore.instance
                        .collection('search')
                        .doc('userSearch')
                        .collection(managerId.docs.first.id)
                        .doc(uid)
                        .delete();
                  });
                });
              }
              // prospect, advisor
              else if (selectedType != null &&
                  selectedType != type &&
                  selectedType == 'Advisor') {
                print('no email, manager to advisor');
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                  'type': 'Advisor',
                  'assignUnder': selectedManager
                }).then((_) async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .where('assignUnder', isEqualTo: fullName)
                      .get()
                      .then((querySnapshot) {
                    querySnapshot.docs.forEach((result) async {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(result.id)
                          .update({'assignUnder': ''});
                    });
                  });

                  await FirebaseFirestore.instance
                      .collection('search')
                      .doc('userSearch')
                      .collection(uid)
                      .where('type', isEqualTo: 'Advisor')
                      .get()
                      .then((snapshot) {
                    for (QueryDocumentSnapshot ds in snapshot.docs) {
                      ds.reference.delete();
                    }
                  }).then((_) async {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .where('fullName', isEqualTo: selectedManager)
                        .limit(1)
                        .get()
                        .then((managerId) async {
                      await FirebaseFirestore.instance
                          .collection('search')
                          .doc('userSearch')
                          .collection(managerId.docs.first.id)
                          .doc(uid)
                          .set({
                        'fullName': (fullNameController.text.isNotEmpty &&
                                fullNameController.text != fullName)
                            ? fullNameController.text
                            : fullName,
                        'type': 'Advisor',
                        'searchCase': caseSearchListSaveToFireBase.toList()
                      });
                    });
                  });
                });
              }

              if (fullNameController.text.isNotEmpty &&
                  fullNameController.text != fullName)
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                  'fullName': fullNameController.text
                  //  (fullNameController.text.isNotEmpty &&
                  //         fullNameController.text != fullName)
                  //     ? fullNameController.text
                  //     : fullName,
                  // 'type': (selectedType != null && selectedType != type)
                  //     ? selectedType
                  //     : type,
                  // 'assignUnder':
                  //     ((selectedType != null && selectedType == "Manager") ||
                  //             (selectedType == null && type == "Manager"))
                  //         ? ""
                  //         : (selectedManager != null &&
                  //                 selectedManager != assignManager)
                  //             ? selectedManager
                  //             : assignManager,
                  // 'password': (userPwdController.text.isNotEmpty &&
                  //         userPwdController.text != password)
                  //     ? userPwdController.text
                  //     : password
                }).then((_) async {
                  await FirebaseFirestore.instance
                      .collection('search')
                      .doc('adminSearch')
                      .collection('search')
                      .doc(uid)
                      .update({
                    'fullName': fullNameController.text.trim(),
                    'searchCase': caseSearchListSaveToFireBase.toList(),
                  });
                });

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'email': emailController.text,
                // 'fullName': (fullNameController.text.isNotEmpty &&
                //         fullNameController.text != fullName)
                //     ? fullNameController.text
                //     : fullName,
                // 'type': (selectedType != null && selectedType != type)
                //     ? selectedType
                //     : type,
                // 'assignUnder':
                //     ((selectedType != null && selectedType == "Manager") ||
                //             (selectedType == null && type == "Manager"))
                //         ? ""
                //         : (selectedManager != null &&
                //                 selectedManager != assignManager)
                //             ? selectedManager
                //             : assignManager,
                // 'password': (userPwdController.text.isNotEmpty &&
                //         userPwdController.text != password)
                //     ? userPwdController.text
                //     : password
              });
              // .then((_) async {
              //   await FirebaseFirestore.instance
              //       .collection('search')
              //       .doc('adminSearch')
              //       .collection('search')
              //       .doc(uid)
              //       .update({
              //     'fullName': fullNameController.text.trim(),
              //     'searchCase': caseSearchListSaveToFireBase.toList()
              //   });
              // });

              // app2 = await Firebase.initializeApp(
              //     name: 'Third', options: Firebase.app().options);

              await FirebaseAuth.instanceFor(app: app)
                  .signInWithEmailAndPassword(email: email, password: password)
                  .then((value) {
                value.user.updateEmail(emailController.text);
              });

              // if ((userPwdController.text.isNotEmpty &&
              //     userPwdController.text != password)) {
              //   await FirebaseAuth.instanceFor(app: app2)
              //       .signInWithEmailAndPassword(
              //           email: emailController.text, password: password)
              //       .then((value) {
              //     value.user.updatePassword(userPwdController.text);
              //   });
              // }

              // await app2.delete();

              setState(() {
                isLoading = false;
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
            if (selectedType != null &&
                selectedType != type &&
                selectedType == 'Manager') {
              print('no email, advisor to manager');
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({'type': 'Manager', 'assignUnder': ''}).then(
                      (_) async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .where('fullName', isEqualTo: assignManager)
                    .limit(1)
                    .get()
                    .then((managerId) async {
                  await FirebaseFirestore.instance
                      .collection('search')
                      .doc('userSearch')
                      .collection(managerId.docs.first.id)
                      .doc(uid)
                      .delete();
                });
              });
            }
            // prospect, advisor
            else if (selectedType != null &&
                selectedType != type &&
                selectedType == 'Advisor') {
              print('no email, manager to advisor');
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                'type': 'Advisor',
                'assignUnder': selectedManager
              }).then((_) async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .where('assignUnder', isEqualTo: fullName)
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((result) async {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(result.id)
                        .update({'assignUnder': ''});
                  });
                });

                await FirebaseFirestore.instance
                    .collection('search')
                    .doc('userSearch')
                    .collection(uid)
                    .where('type', isEqualTo: 'Advisor')
                    .get()
                    .then((snapshot) {
                  for (QueryDocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                }).then((_) async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .where('fullName', isEqualTo: selectedManager)
                      .limit(1)
                      .get()
                      .then((managerId) async {
                    await FirebaseFirestore.instance
                        .collection('search')
                        .doc('userSearch')
                        .collection(managerId.docs.first.id)
                        .doc(uid)
                        .set({
                      'fullName': (fullNameController.text.isNotEmpty &&
                              fullNameController.text != fullName)
                          ? fullNameController.text
                          : fullName,
                      'type': 'Advisor',
                      'searchCase': caseSearchListSaveToFireBase.toList()
                    });
                  });
                });
              });
            }

            if (fullNameController.text.isNotEmpty &&
                fullNameController.text != fullName)
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .update({
                // 'email': email,
                'fullName': fullNameController.text
                //  (fullNameController.text.isNotEmpty &&
                //         fullNameController.text != fullName)
                //     ? fullNameController.text
                //     : fullName,
                // 'type': (selectedType != null && selectedType != type)
                //     ? selectedType
                //     : type,
                // 'assignUnder':
                //     ((selectedType != null && selectedType == "Manager") ||
                //             (selectedType == null && type == "Manager"))
                //         ? ""
                //         : (selectedManager != null &&
                //                 selectedManager != assignManager)
                //             ? selectedManager
                //             : assignManager,
                // 'password': (userPwdController.text.isNotEmpty &&
                //         userPwdController.text != password)
                //     ? userPwdController.text
                //     : password
              }).then((_) async {
                await FirebaseFirestore.instance
                    .collection('search')
                    .doc('adminSearch')
                    .collection('search')
                    .doc(uid)
                    .update({
                  'fullName': fullNameController.text.trim(),
                  'searchCase': caseSearchListSaveToFireBase.toList(),
                });
              });

            // if (!(userPwdController.text.isEmpty ||
            //     userPwdController.text == password)) {

            //   await FirebaseAuth.instanceFor(app: app2)
            //       .signInWithEmailAndPassword(email: email, password: password)
            //       .then((value) {
            //     value.user.updatePassword(userPwdController.text);
            //   });

            // }

            setState(() {
              isLoading = false;
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

      await FirebaseAuth.instanceFor(app: app)
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        value.user.delete();
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .delete()
          .then((_) async {
        await FirebaseFirestore.instance
            .collection('search')
            .doc('adminSearch')
            .collection('search')
            .doc(uid)
            .delete();

        await FirebaseFirestore.instance
            .collection('search')
            .doc('userSearch')
            .collection(uid)
            .get()
            .then((snapshot) {
          for (QueryDocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(err.message),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
