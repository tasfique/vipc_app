import 'package:flutter/foundation.dart';

class Prospect {
  String prospectId;
  String prospectName;
  String phoneNo;
  String email;
  String type;
  Map<String, dynamic> step;
  String lastUpdate;
  String memo;

  Prospect(
      {@required this.prospectId,
      @required this.prospectName,
      @required this.phoneNo,
      @required this.email,
      @required this.type,
      @required this.step,
      @required this.lastUpdate,
      @required this.memo});
}
