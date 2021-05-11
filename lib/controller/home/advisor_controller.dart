import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:vipc_app/model/member.dart';
import 'dart:async';
import 'dart:convert';

class AdvisorController extends ControllerMVC {
  factory AdvisorController() {
    if (_this == null) _this = AdvisorController._();
    return _this;
  }
  static AdvisorController _this;
  AdvisorController._();

  static AdvisorController get con => _this;
  int selectedIndex;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<Member> fetchMember() async {
    final url = 'https://jsonplaceholder.typicode.com/users/1';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Member.fromJson(jsonBody);
    } else {
      throw Exception("Failed to load member data");
    }
  }
}
