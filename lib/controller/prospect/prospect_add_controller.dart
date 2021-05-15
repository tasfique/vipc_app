import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProspectAddController extends ControllerMVC {
  factory ProspectAddController() {
    if (_this == null) _this = ProspectAddController._();
    return _this;
  }
  static ProspectAddController _this;
  ProspectAddController._();

  static ProspectAddController get con => _this;

  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'add_prospect');
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final memoController = TextEditingController();
  String selectedType;
  bool addSuccess;
  bool isLoading;
  bool isValid;
  FirebaseApp app;

  void start() async {
    usernameController.clear();
    phoneController.clear();
    emailController.clear();
    memoController.clear();
    selectedType = null;
    addSuccess = false;
    isLoading = false;
    isValid = false;
    app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
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

  Future<void> addProspect(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        List<String> caseSearchListSaveToFireBase =
            setSearchParam(usernameController.text.trim());

        String userId = FirebaseAuth.instance.currentUser.uid;
        String time = DateTime.now().toIso8601String().toString();

        await FirebaseFirestore.instance
            .collection('prospect')
            .doc(userId)
            .collection('prospects')
            .add({
          'prospectName': usernameController.text.trim(),
          'done': 0,
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'type': selectedType,
          'lastUpdate': time,
          'lastStep': 0,
          'steps': {
            'length': 1,
            '0Time': time,
            '0': 'New Prospect',
            '0Point': 1,
            '0meetingPlace': '',
            '0meetingDate': '',
            '0meetingTime': '',
            '0memo': memoController.text.trim(),
          }
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('search')
              .doc('userSearch')
              .collection(userId)
              .doc(value.id)
              .set({
            'prospectName': usernameController.text.trim(),
            'phone': phoneController.text.trim(),
            'searchCase': caseSearchListSaveToFireBase.toList()
          });
        });

        setState(() {
          isLoading = false;
          addSuccess = true;
        });
      } catch (error) {
        setState(() {
          addSuccess = false;
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
