import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/prospect.dart';

enum Choices { edit, update }

class ProspectEditController extends ControllerMVC {
  factory ProspectEditController() {
    if (_this == null) _this = ProspectEditController._();
    return _this;
  }
  static ProspectEditController _this;
  ProspectEditController._();

  static ProspectEditController get con => _this;

  Choices choice;
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'prospect_edit');
  bool editSuccess;
  bool isLoading;
  bool isValid;
  FirebaseApp app;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  String selectedType;
  String selectedStep;
  Prospect prospect;
  int length;
  String userId;

  void start() async {
    editSuccess = false;
    isLoading = false;
    isValid = false;
    selectedType = null;
    selectedStep = null;
    choice = Choices.edit;
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    placeController.clear();
    dateController.clear();
    timeController.clear();
    memoController.clear();
    userId = FirebaseAuth.instance.currentUser.uid;
    app = await Firebase.initializeApp(
        name: 'Third', options: Firebase.app().options);
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

  Future<void> editProspect(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        var time;

        if (choice == Choices.edit) {
          if (length != 0) {
            if (timeController.text.isNotEmpty && dateController.text.isEmpty) {
              TimeOfDay t = TimeOfDay(
                  hour: int.parse(timeController.text.substring(0, 2)),
                  minute: int.parse(timeController.text.substring(3, 5)));
              final now =
                  DateTime.parse(prospect.steps['${length}meetingDate']);
              time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            } else if (timeController.text.isNotEmpty &&
                dateController.text.isNotEmpty) {
              TimeOfDay t = TimeOfDay(
                  hour: int.parse(timeController.text.substring(0, 2)),
                  minute: int.parse(timeController.text.substring(3, 5)));
              final now = DateTime.parse(dateController.text);
              time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            } else if (timeController.text.isEmpty &&
                dateController.text.isEmpty &&
                prospect.steps['${length}meetingTime'] == '') {
              final now =
                  DateTime.parse(prospect.steps['${length}meetingDate']);
              time = DateTime(now.year, now.month, now.day, 0, 0);
            } else if (timeController.text.isEmpty &&
                dateController.text.isEmpty &&
                prospect.steps['${length}meetingTime'] != '') {
              TimeOfDay t = TimeOfDay(
                  hour: int.parse(
                      prospect.steps['${length}meetingTime'].substring(0, 2)),
                  minute: int.parse(
                      prospect.steps['${length}meetingTime'].substring(3, 5)));
              final now =
                  DateTime.parse(prospect.steps['${length}meetingDate']);
              time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            } else if (timeController.text.isEmpty &&
                dateController.text.isNotEmpty &&
                prospect.steps['${length}meetingTime'] == '') {
              final now = DateTime.parse(dateController.text);
              time = DateTime(now.year, now.month, now.day, 0, 0);
            } else if (timeController.text.isEmpty &&
                dateController.text.isNotEmpty &&
                prospect.steps['${length}meetingTime'] != '') {
              TimeOfDay t = TimeOfDay(
                  hour: int.parse(
                      prospect.steps['${length}meetingTime'].substring(0, 2)),
                  minute: int.parse(
                      prospect.steps['${length}meetingTime'].substring(3, 5)));
              final now = DateTime.parse(dateController.text);
              time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            }
          }

          List<String> caseSearchListSaveToFireBase;
          await FirebaseFirestore.instance
              .collection('prospect')
              .doc(userId)
              .collection('prospects')
              .doc(prospect.prospectId)
              .update({
            'prospectName': (nameController.text.isNotEmpty &&
                    nameController.text != prospect.prospectName)
                ? nameController.text
                : prospect.prospectName,
            'phone': (phoneController.text.isNotEmpty &&
                    phoneController.text != prospect.phoneNo)
                ? phoneController.text
                : prospect.phoneNo,
            'email': (emailController.text.isNotEmpty &&
                    emailController.text != prospect.email)
                ? emailController.text
                : prospect.email,
            'type': (selectedType != null && selectedType != prospect.type)
                ? selectedType
                : prospect.type,
            'lastUpdate':
                length != 0 ? time.toIso8601String() : prospect.lastUpdate,
            'steps.${length}meetingPlace': (placeController.text.isNotEmpty &&
                    placeController.text !=
                        prospect.steps['${length}meetingPlace'] &&
                    length != 0)
                ? placeController.text
                : prospect.steps['${length}meetingPlace'],
            'steps.${length}meetingDate': (dateController.text.isNotEmpty &&
                    dateController.text !=
                        prospect.steps['${length}meetingDate'] &&
                    length != 0)
                ? dateController.text
                : prospect.steps['${length}meetingDate'],
            'steps.${length}meetingTime': (timeController.text.isNotEmpty &&
                    timeController.text !=
                        prospect.steps['${length}meetingTime'] &&
                    length != 0)
                ? timeController.text
                : prospect.steps['${length}meetingTime'],
            'steps.${length}memo': (memoController.text.isNotEmpty &&
                    memoController.text != prospect.steps['${length}memo'])
                ? memoController.text
                : prospect.steps['${length}memo'],
            'steps.${length}noti': (dateController.text.isNotEmpty &&
                    dateController.text !=
                        prospect.steps['${length}meetingDate'] &&
                    length != 0)
                ? false
                : prospect.steps['${length}noti'],
          }).then((_) async {
            if (nameController.text.isNotEmpty &&
                nameController.text != prospect.prospectName) {
              caseSearchListSaveToFireBase =
                  setSearchParam(nameController.text.trim());
              await FirebaseFirestore.instance
                  .collection('search')
                  .doc('userSearch')
                  .collection(userId)
                  .doc(prospect.prospectId)
                  .update({
                'prospectName': nameController.text.trim(),
                'searchCase': caseSearchListSaveToFireBase.toList()
              });
            }

            if (phoneController.text.isNotEmpty &&
                phoneController.text != prospect.phoneNo)
              await FirebaseFirestore.instance
                  .collection('search')
                  .doc('userSearch')
                  .collection(userId)
                  .doc(prospect.prospectId)
                  .update({
                'phone': phoneController.text.trim(),
              });
          });
        } else if (choice == Choices.update) {
          if (timeController.text.isNotEmpty) {
            TimeOfDay t = TimeOfDay(
                hour: int.parse(timeController.text.substring(0, 2)),
                minute: int.parse(timeController.text.substring(3, 5)));
            final now = DateTime.parse(dateController.text);
            time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          } else if (timeController.text.isEmpty) {
            final now = DateTime.parse(dateController.text);
            time = DateTime(now.year, now.month, now.day, 0, 0);
          }

          int step = int.parse(selectedStep.substring(5, 6));
          int point;

          switch (step) {
            case 1:
              point = 2;
              break;
            case 2:
              point = 2;
              break;
            case 3:
              point = 1;
              break;
            case 4:
              point = 4;
              break;
            case 5:
              point = 5;
              break;
            case 6:
              point = 1;
              break;
          }

          await FirebaseFirestore.instance
              .collection('prospect')
              .doc(userId)
              .collection('prospects')
              .doc(prospect.prospectId)
              .update({
            'steps.${length + 1}': selectedStep,
            'lastUpdate': time.toIso8601String(),
            'lastStep': step,
            'steps.length': length + 2,
            'steps.${length + 1}Point': point,
            'steps.${length + 1}meetingPlace':
                placeController.text.isNotEmpty ? placeController.text : '',
            'steps.${length + 1}meetingDate': dateController.text,
            'steps.${length + 1}meetingTime':
                timeController.text.isNotEmpty ? timeController.text : '',
            'steps.${length + 1}memo':
                memoController.text.isNotEmpty ? memoController.text : '',
            'steps.${length + 1}noti': false
          });
        }

        setState(() {
          isLoading = false;
          editSuccess = true;
        });
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
    }
  }

  Future<void> deleteProspect(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('prospect')
          .doc(userId)
          .collection('prospects')
          .doc(prospect.prospectId)
          .delete()
          .then((_) async {
        await FirebaseFirestore.instance
            .collection('search')
            .doc('userSearch')
            .collection(userId)
            .doc(prospect.prospectId)
            .delete();
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
