import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:vipc_app/model/member.dart';
import 'dart:async';
import 'dart:convert';

import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/prospect.dart';

class AdvisorController extends ControllerMVC {
  factory AdvisorController() {
    if (_this == null) _this = AdvisorController._();
    return _this;
  }
  static AdvisorController _this;
  AdvisorController._();

  static AdvisorController get con => _this;
  int selectedIndex;
  List<News> newsList;
  List<Prospect> prospectList;
  List<Prospect> prospectCardList;
  List<int> monthlyPoint = [];

  String dropdownValue = 'Sort by Time';
  String sort = 'up';

  Future<void> getNews(BuildContext context) async {
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

  Future<void> getProspect(BuildContext context) async {
    List<Prospect> newsProspectListTemp = [];

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      if (dropdownValue == 'Sort by Time')
        prospects = await FirebaseFirestore.instance
            .collection("prospect")
            .doc(userId)
            .collection('prospects')
            .orderBy('lastUpdate', descending: sort != 'up')
            .get();
      else if (dropdownValue == 'Sort by Step')
        prospects = await FirebaseFirestore.instance
            .collection("prospect")
            .doc(userId)
            .collection('prospects')
            .orderBy('lastStep', descending: sort != 'up')
            .get();

      prospects.docs.forEach((oneProspect) {
        if (oneProspect.data()['done'] == 0)
          newsProspectListTemp.add(Prospect(
            prospectId: oneProspect.id,
            prospectName: oneProspect.data()['prospectName'],
            phoneNo: oneProspect.data()['phone'],
            email: oneProspect.data()['email'],
            type: oneProspect.data()['type'],
            steps: oneProspect.data()['steps'],
            lastUpdate: oneProspect.data()['lastUpdate'],
            lastStep: oneProspect.data()['lastStep'],
            done: oneProspect.data()['done'],
          ));
      });
      prospectList = newsProspectListTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getProspectCard(BuildContext context) async {
    List<Prospect> newsProspectListTemp = [];
    DateTime present = DateTime.now();
    DateTime time;

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .orderBy('lastUpdate', descending: false)
          .get();

      prospects.docs.forEach((oneProspect) {
        if (oneProspect.data()['done'] == 0 &&
            oneProspect.data()['lastStep'] != 0) {
          time = DateTime.parse(oneProspect.data()['lastUpdate']);
          if (time.difference(present).inSeconds > 0)
            newsProspectListTemp.add(Prospect(
              prospectId: oneProspect.id,
              prospectName: oneProspect.data()['prospectName'],
              phoneNo: oneProspect.data()['phone'],
              email: oneProspect.data()['email'],
              type: oneProspect.data()['type'],
              steps: oneProspect.data()['steps'],
              lastUpdate: oneProspect.data()['lastUpdate'],
              lastStep: oneProspect.data()['lastStep'],
              done: oneProspect.data()['done'],
            ));
        }
      });
      prospectCardList = newsProspectListTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getMonthlyPoint(BuildContext context) async {
    // List<Prospect> newsProspectListTemp = [];
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    print(currentMonth);
    // for (int i = 0; i < 12; i++) monthlyPoint.add(0);
// monthlyPoint = 0

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      for (int i = 0; i < 12; i++) {
        monthlyPoint[i] = 0;
      }

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        // time = DateTime.parse(oneProspect.data()['lastUpdate']);
        // if (time.difference(present).inSeconds > 0)
        //   newsProspectListTemp.add(Prospect(
        //     prospectId: oneProspect.id,
        //     prospectName: oneProspect.data()['prospectName'],
        //     phoneNo: oneProspect.data()['phone'],
        //     email: oneProspect.data()['email'],
        //     type: oneProspect.data()['type'],
        //     steps: oneProspect.data()['steps'],
        //     lastUpdate: oneProspect.data()['lastUpdate'],
        //     lastStep: oneProspect.data()['lastStep'],
        //     done: oneProspect.data()['done'],
        //   ));
        // print(oneProspect.data()['steps']['length']);

        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear)
          monthlyPoint[createdTime.month - 1]++;
        for (int i = 1; i < oneProspect.data()['steps']['length']; i++) {
          if (oneProspect.data()['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month <= currentMonth)
            monthlyPoint[now.month - 1] +=
                oneProspect.data()['steps']['${i}Point'];
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
