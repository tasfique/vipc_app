import 'package:flutter/foundation.dart';

class Usr {
  String userId;
  String email;
  String fullName;
  String empID;
  String type;
  String assignUnder;
  String password;

  Usr(
      {@required this.userId,
      @required this.empID,
      @required this.email,
      @required this.fullName,
      @required this.type,
      @required this.assignUnder,
      @required this.password});
}
