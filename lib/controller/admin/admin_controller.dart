import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';

class AdminController extends ControllerMVC {
  factory AdminController() {
    if (_this == null) _this = AdminController._();
    return _this;
  }
  static AdminController _this;
  AdminController._();

  static AdminController get con => _this;

  int selectedIndex = 0;
  // int selectedNewsIndex = 0;
  List<Usr> userList;
  List<News> newsList;
  // List<String> managers;

  // bool isLoadingUser;

  // void getManagerList(BuildContext context) async {
  //   List<String> managerListTemp = [];

  //   try {
  //     setState(() {
  //       managers.clear();
  //     });
  //     final managerList = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('type', isEqualTo: 'Manager')
  //         .get();
  //     managerList.docs.forEach((result) {
  //       managerListTemp.add(result.data()['fullName']);
  //       managers = managerListTemp;
  //     });
  //   } catch (err) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Error, couldn\'s load data.'),
  //           backgroundColor: Theme.of(context).errorColor),
  //     );
  //   }
  // }

  Future<void> getUser(BuildContext context) async {
    // setState(() {
    //   isLoadingUser = true;
    // });
    //
    List<Usr> userListTemp = [];

    try {
      // setState(() {
      //   userList.clear();
      // });
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

    // setState(() {
    //   isLoadingUser = false;
    // });
  }

  Future<void> getNews(BuildContext context) async {
    // setState(() {
    //   isLoadingUser = true;
    // });
    //
    //
    // setState(() {
    //   newsList.clear();
    // });

    List<News> newsListTemp = [];

    try {
      final news = await FirebaseFirestore.instance.collection("news").get();

      news.docs.forEach((oneNew) {
        // DateFormat('dd/MM/yyyy hh:mm')
        // .format(DateTime.parse(oneNew.id.toString()));
        // DateFormat('dd/MM/yyyy hh:mm').parse(oneNew.id);
        if (oneNew.data()['images'] == null) {
          newsListTemp.add(News(
            newsId: oneNew.id,
            title: oneNew.data()['title'],
            content: oneNew.data()['content'],
            // dateCreated: oneNew.id,
            // imageUrl: oneNew.data()['images'],
          ));
        } else {
          newsListTemp.add(News(
            newsId: oneNew.id,
            title: oneNew.data()['title'],
            content: oneNew.data()['content'],
            // dateCreated: oneNew.id,
            imageUrl: oneNew.data()['images'],
          ));
        }
      });
      newsList = newsListTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
