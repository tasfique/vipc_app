import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:intl/intl.dart';

class MonitorController extends ControllerMVC {
  factory MonitorController() {
    if (_this == null) _this = MonitorController._();
    return _this;
  }
  static MonitorController _this;
  MonitorController._();

  static MonitorController get con => _this;

  List<Prospect> prospectList;
  List<Prospect> prospectCardList;
  List<int> weeklyPoint = [0, 0, 0, 0];
  List<int> prospectStatus = [0, 0];
  List<int> monthlyPoint = [];
  int currentMonthPoint = 0;
  int currentWeekPoint = 0;
  DateTime minimumDate;
  DateTime fromDate, toDate;
  Map<String, int> rangePoint = {};
  List<DateTime> rangeTime;
  int numIndex;
  bool weekPoint = false;
  List<Prospect> prospectListRequestPassword = [];
  int meetingCount = 0;
  String userId;

  Future<void> getProspectStatus(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    minimumDate = DateTime.now();

    try {
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      for (int i = 0; i < 2; i++) {
        prospectStatus[i] = 0;
      }

      TimeOfDay t;
      var now;
      var time;

      prospects.docs.forEach((oneProspect) {
        if (DateTime.parse(oneProspect.data()['steps']['0Time'])
                .difference(minimumDate)
                .inSeconds <=
            0)
          minimumDate = DateTime.parse(oneProspect.data()['steps']['0Time']);

        int length = oneProspect.data()['steps']['length'] - 1;

        if (oneProspect.data()['steps']['$length'] ==
            'Step 6 Referral/Servicing') {
          if (oneProspect.data()['steps']['${length}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${length}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${length}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(
              oneProspect.data()['steps']['${length}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month == currentMonth)
            prospectStatus[0]++;
          else
            prospectStatus[1]++;
        } else
          prospectStatus[1]++;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getWeeklyPoint(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    currentWeekPoint = 0;

    try {
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      for (int i = 0; i < 4; i++) {
        weeklyPoint[i] = 0;
      }

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear &&
            createdTime.month ==
                currentMonth) if (createdTime.day >= 1 && createdTime.day <= 7)
          weeklyPoint[0]++;
        else if (createdTime.day >= 8 && createdTime.day <= 14)
          weeklyPoint[1]++;
        else if (createdTime.day >= 15 && createdTime.day <= 21)
          weeklyPoint[2]++;
        else
          weeklyPoint[3]++;

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
              now.month == currentMonth) if (time.day >= 1 && time.day <= 7)
            weeklyPoint[0] += oneProspect.data()['steps']['${i}Point'];
          else if (time.day >= 8 && time.day <= 14)
            weeklyPoint[1] += oneProspect.data()['steps']['${i}Point'];
          else if (time.day >= 15 && time.day <= 21)
            weeklyPoint[2] += oneProspect.data()['steps']['${i}Point'];
          else
            weeklyPoint[3] += oneProspect.data()['steps']['${i}Point'];
        }
      });
      if (present.day >= 1 && present.day <= 7)
        currentWeekPoint = weeklyPoint[0].toInt();
      else if (present.day >= 8 && present.day <= 14)
        currentWeekPoint = weeklyPoint[1].toInt();
      else if (present.day >= 15 && present.day <= 21)
        currentWeekPoint = weeklyPoint[2].toInt();
      else
        currentWeekPoint = weeklyPoint[3].toInt();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getMonthlyPoint(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;

    try {
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

  Future<void> getRangePoint(BuildContext context) async {
    DateTime present = DateTime.now();

    double numIndexD = toDate.difference(fromDate).inDays / 30;
    numIndex = numIndexD.toInt();
    rangePoint = {};
    rangeTime = [];
    String date;
    for (int i = 0; i <= numIndex; i++) {
      date = DateFormat('MM/yyyy')
          .format(DateTime(fromDate.year, fromDate.month + i, 1, 0, 0, 0))
          .toString();
      rangeTime.add(DateTime(fromDate.year, fromDate.month + i));
      rangePoint['$date'] = 0;
    }

    try {
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);

        if (DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
                    .difference(
                        DateTime(fromDate.year, fromDate.month, 1, 0, 0, 0))
                    .inSeconds >=
                0 &&
            DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
                    .difference(DateTime(toDate.year, toDate.month, 1, 0, 0, 0))
                    .inSeconds <=
                0) {
          date = DateFormat('MM/yyyy')
              .format(DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0))
              .toString();
          rangePoint['$date'] += 1;
        }

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
          date = DateFormat('MM/yyyy')
              .format(
                  DateTime(time.year, time.month, now.day, t.hour, t.minute))
              .toString();
          if (time
                      .difference(
                          DateTime(fromDate.year, fromDate.month, 1, 0, 0, 0))
                      .inSeconds >=
                  0 &&
              time
                      .difference(
                          DateTime(toDate.year, toDate.month + 1, 0, 0, 0, 0))
                      .inSeconds <=
                  0 &&
              time.difference(present).inSeconds <= 0)
            rangePoint['$date'] += oneProspect.data()['steps']['${i}Point'];
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
