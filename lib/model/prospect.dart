import 'package:flutter/foundation.dart';

class Prospect {
  String prospectId;
  String prospectName;
  String phoneNo;
  String email;
  String type;
  Map<String, dynamic> steps;
  String lastUpdate;
  int lastStep;
  int done;

  Prospect({
    @required this.prospectId,
    @required this.prospectName,
    @required this.phoneNo,
    @required this.email,
    @required this.type,
    @required this.steps,
    @required this.lastUpdate,
    @required this.lastStep,
    @required this.done,
  });
}
