import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vipc_app/view/admin/admin_home_view.dart';
import 'package:vipc_app/view/home/advisor_view.dart';
import 'package:vipc_app/view/home/manager_view.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vipc_app/view/splash/splash_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.apps.toList().clear();
  await Firebase.initializeApp();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey[800],
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
        title: 'Great Ideals',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          //added Accent colour.
          accentColor: Colors.amber[400],
          //added canvas colour for hamburger to have dark background.
          //canvasColor is changing the background colour globally.
          canvasColor: Colors.grey[800],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          //changing the text color into white globally
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            //here the bodyColor below changes the text color.
            bodyColor: Colors.grey[50],
            displayColor: Colors.amberAccent,
          ),
        ),
        home: VipC(null));
  }
}

class VipC extends StatefulWidget {
  final RemoteMessage message;
  VipC(this.message);

  @override
  _VipCState createState() => _VipCState();
}

class _VipCState extends State<VipC> {
  static int _count = 0;

  void tomorrowNotification() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where("token", isNotEqualTo: '')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        if (element.data()['type'] != 'Admin') {
          await FirebaseFirestore.instance
              .collection('prospect')
              .doc(element.id)
              .collection('prospects')
              .where('steps.length', isGreaterThan: 1)
              .get()
              .then((value) {
            value.docs.forEach((oneProspect) async {
              int lastIndex = oneProspect.data()['steps']['length'] - 1;
              DateTime present = DateTime.now();
              DateTime time;

              time = DateTime.parse(oneProspect.data()['lastUpdate']);
              if (time.day != present.day &&
                  time.difference(present).inDays <= 1 &&
                  present.hour >= 8 &&
                  present.hour <= 20 &&
                  time.difference(present).inSeconds > 0 &&
                  time.difference(present).inHours < 24 &&
                  !oneProspect.data()['steps']['${lastIndex}noti']) {
                String severToken =
                    'AAAAQ2vv-_M:APA91bGWibt_2dMmTc7p32PD17hEt4aRzJlEKCUX62817BxxVYtPB2uSErpXiGECayd03rlLg2HqgGYMB9N6ugO5kyGnbPdVDskgHhNmmmTXIVNCzp8l9sjpnPiGE_NKCjHpcbhi--Df';
                await http.post('https://fcm.googleapis.com/fcm/send',
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': 'key=$severToken',
                    },
                    body: jsonEncode(
                      <String, dynamic>{
                        'notification': <String, dynamic>{
                          'title': 'Meeting Tomorrow',
                          'body': '\nYou have meeting tomorrow with the prospect: ${oneProspect.data()['prospectName']}\nTime: ' +
                              (DateFormat('HH:mm').format(DateTime.parse(
                                          oneProspect.data()['lastUpdate'])) !=
                                      '00:00'
                                  ? DateFormat('dd/MM/yyyy HH:mm').format(
                                      DateTime.parse(
                                          oneProspect.data()['lastUpdate']))
                                  : DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          oneProspect.data()['lastUpdate']))) +
                              (oneProspect.data()['steps']
                                          ['${lastIndex}meetingPlace'] ==
                                      ''
                                  ? ''
                                  : '\nMeeting at ${oneProspect.data()['steps']['${lastIndex}meetingPlace']}'),
                        },
                        'priority': 'high',
                        'data': <String, dynamic>{
                          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                          'status': 'done'
                        },
                        'to': element.data()['token'],
                      },
                    ));
                await FirebaseFirestore.instance
                    .collection('prospect')
                    .doc(element.id)
                    .collection('prospects')
                    .doc(oneProspect.id)
                    .update({'steps.${lastIndex}noti': true});
              }
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.message != null && _count == 0) {
        _count++;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: ListTile(
                title: Text(
                  widget.message.notification.title,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(widget.message.notification.body,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ).then((value) => _count = 0);
      }
    });

    if (_count == 0) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _count++;
        if (_count == 1) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: ListTile(
                  title: Text(
                    message.notification.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(message.notification.body,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
              actions: [
                TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          ).then((value) {
            Future.delayed(Duration(milliseconds: 100), () {
              _count = 0;
            });
          });
        }
        _count++;
      });
    }

    Future.delayed(Duration(milliseconds: 100), () {
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => VipC(message)));
      });
    });

    Future.delayed(Duration(milliseconds: 100), () {
      FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => VipC(message)));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (userSnapshot.hasData) {
          tomorrowNotification();
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userSnapshot.data.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final userDoc = snapshot.data;
                final user = userDoc.data();
                if (user['type'] == 'Admin') {
                  return AdminPage();
                } else if (user['type'] == 'Manager') {
                  return ManagerView();
                } else if (user['type'] == 'Advisor') {
                  return AdvisorView();
                }
              }
              return LoginView();
            },
          );
        }
        return LoginView();
      },
    );
  }
}
