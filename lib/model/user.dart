import 'package:flutter/foundation.dart';

class User {
  String userId;
  String email;
  String fullName;
  String empID;
  String type;
  String assignUnder;

  User(
      {@required this.userId,
      @required this.empID,
      @required this.email,
      @required this.fullName,
      @required this.type,
      @required this.assignUnder});
}
