import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/prospect.dart';

class ProspectViewController extends ControllerMVC {
  factory ProspectViewController() {
    if (_this == null) _this = ProspectViewController._();
    return _this;
  }
  static ProspectViewController _this;
  ProspectViewController._();

  static ProspectViewController get con => _this;
}
