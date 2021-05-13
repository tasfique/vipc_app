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
  String dropdownValue = 'Sort by Time';

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
            .orderBy('lastUpdate', descending: true)
            .get();
      else if (dropdownValue == 'Sort by Step')
        prospects = await FirebaseFirestore.instance
            .collection("prospect")
            .doc(userId)
            .collection('prospects')
            .orderBy('steps.length', descending: true)
            .get();

      prospects.docs.forEach((oneProspect) {
        newsProspectListTemp.add(Prospect(
          prospectId: oneProspect.id,
          prospectName: oneProspect.data()['prospectName'],
          phoneNo: oneProspect.data()['phone'],
          email: oneProspect.data()['email'],
          type: oneProspect.data()['type'],
          step: oneProspect.data()['steps'],
          lastUpdate: oneProspect.data()['lastUpdate'],
          memo: oneProspect.data()['memo'],
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
}
