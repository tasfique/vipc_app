import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:vipc_app/model/member.dart';
import 'dart:async';
import 'dart:convert';

import 'package:vipc_app/model/news.dart';

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
