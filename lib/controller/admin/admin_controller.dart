import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';
import 'package:http/http.dart' as http;

class AdminController extends ControllerMVC {
  factory AdminController() {
    if (_this == null) _this = AdminController._();
    return _this;
  }
  static AdminController _this;
  AdminController._();

  static AdminController get con => _this;

  int selectedIndex = 0;
  Usr adminDetail;
  List<Usr> userList;
  List<Usr> userListRequestPassword;
  List<News> newsList;
  final empNoController = TextEditingController();
  GlobalKey<FormState> formKeyForget =
      GlobalKey<FormState>(debugLabel: 'request_changing_password');
  bool isValid;
  bool isLoading;
  bool requestSuccess;
  int requestPasswordCount;
  String forgotPasswordType;
  final String severToken =
      'AAAAQ2vv-_M:APA91bGWibt_2dMmTc7p32PD17hEt4aRzJlEKCUX62817BxxVYtPB2uSErpXiGECayd03rlLg2HqgGYMB9N6ugO5kyGnbPdVDskgHhNmmmTXIVNCzp8l9sjpnPiGE_NKCjHpcbhi--Df';

  void clean() {
    isValid = false;
    isLoading = false;
    requestSuccess = false;
    empNoController.clear();
  }

  Future<void> getAdminDetail() async {
    final admin = await FirebaseFirestore.instance
        .collection("users")
        .where("type", isEqualTo: 'Admin')
        .get();

    adminDetail = Usr(
        userId: admin.docs.first.id,
        empID: admin.docs.first.data()['empID'],
        email: admin.docs.first.data()['email'],
        fullName: admin.docs.first.data()['fullName'],
        type: admin.docs.first.data()['type'],
        assignUnder: admin.docs.first.data()['assignUnder'],
        password: admin.docs.first.data()['password']);
  }

  Future<void> requestChangePassword(BuildContext context) async {
    forgotPasswordType = '';
    FocusScope.of(context).unfocus();
    isValid = formKeyForget.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .where('empID', isEqualTo: empNoController.text)
            .limit(1)
            .get();

        if (userData.docs.length == 1) {
          if (userData.docs.first.data()['type'] != 'Admin') {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userData.docs.first.id)
                .update({'requestChangingPassword': '1'});

            setState(() {
              isLoading = false;
              requestSuccess = true;
            });

            String token = '';
            await FirebaseFirestore.instance
                .collection('users')
                .where('type', isEqualTo: 'Admin')
                .get()
                .then((value) {
              token = value.docs[0]['token'];
            });

            await http.post('https://fcm.googleapis.com/fcm/send',
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  'Authorization': 'key=$severToken',
                },
                body: jsonEncode(
                  <String, dynamic>{
                    'notification': <String, dynamic>{
                      'title': 'Request To Change Password',
                      'body':
                          'User Name: ${userData.docs.first.data()['fullName']}\nUser ID: ${empNoController.text}\nRequest to change their password.',
                    },
                    'priority': 'high',
                    'data': <String, dynamic>{
                      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                      'status': 'done'
                    },
                    'to': token,
                  },
                ));
          } else {
            forgotPasswordType = 'Admin';
            setState(() {
              isLoading = false;
              requestSuccess = true;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('User ID does not Exist.'),
                backgroundColor: Theme.of(context).errorColor),
          );
          setState(() {
            requestSuccess = false;
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          requestSuccess = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error! ${error.toString()}'),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
    } else {
      setState(() {
        requestSuccess = false;
        isLoading = false;
      });
    }
  }

  Future<void> getRequestPasswordCount() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .where('requestChangingPassword', isEqualTo: '1')
        .get();

    setState(() {
      requestPasswordCount = userData.docs.length;
    });
  }

  Future<void> getUser(BuildContext context) async {
    List<Usr> userListTemp = [];
    getRequestPasswordCount();

    try {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .where("type", whereIn: ["Manager", "Advisor"]).get();

      users.docs.forEach((user) {
        userListTemp.add(Usr(
            userId: user.id,
            empID: user.data()['empID'],
            email: user.data()['email'],
            fullName: user.data()['fullName'],
            type: user.data()['type'],
            assignUnder: user.data()['assignUnder'],
            password: user.data()['password']));
      });
      userList = userListTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getNews(BuildContext context) async {
    getRequestPasswordCount();

    List<News> newsListTemp = [];

    try {
      final news = await FirebaseFirestore.instance.collection("news").get();

      news.docs.forEach((oneNew) {
        if (oneNew.data()['images'] == null) {
          newsListTemp.add(News(
            newsId: oneNew.id,
            title: oneNew.data()['title'],
            content: oneNew.data()['content'],
          ));
        } else {
          newsListTemp.add(News(
            newsId: oneNew.id,
            title: oneNew.data()['title'],
            content: oneNew.data()['content'],
            imageUrl: oneNew.data()['images'],
          ));
        }
      });
      newsList = newsListTemp.reversed.toList();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getRequestedPasswordUser(BuildContext context) async {
    List<Usr> userListRequestTemp = [];

    try {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .where("requestChangingPassword", isEqualTo: '1')
          .get();

      users.docs.forEach((user) {
        userListRequestTemp.add(Usr(
            userId: user.id,
            empID: user.data()['empID'],
            email: user.data()['email'],
            fullName: user.data()['fullName'],
            type: user.data()['type'],
            assignUnder: user.data()['assignUnder'],
            password: user.data()['password']));
      });
      userListRequestPassword = userListRequestTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
