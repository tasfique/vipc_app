import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vipc_app/view/admin/admin_home_view.dart';
import 'package:vipc_app/view/home/home_view.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vipc_app/view/notifications/admin_notification_view.dart';
import 'package:vipc_app/view/search/admin_search_view.dart';
import 'package:vipc_app/view/splash/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.apps.toList().clear();
  await Firebase.initializeApp();
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
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  int _count = 0;
  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();

    print('Token:  $fcmToken');
  }

  @override
  void initState() {
    print(_count);
    Future.delayed(Duration.zero, () {
      if (widget.message != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(widget.message.notification.title),
              subtitle: Text(widget.message.notification.body),
            ),
            actions: [
              TextButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    });

    _saveDeviceToken();

    if (_count == 0) {
      _count++;

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(_count);
        print('testonmessage');

        // print('Got a message whilst in the foreground!');
        // print('Message data: ${message.data}');

        // if (message.notification != null) {
        //   print('Message also contained a notification: ${message.notification}');
        // }

        // print('onMessage: ${message.data}');
        if (_count == 1) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message.notification.title),
                subtitle: Text(message.notification.body),
              ),
              actions: [
                TextButton(
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // print(_count);
                      _count = 0;
                      // print(_count);
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    }
                    // if (message.data['click_action'] !=
                    //     'FLUTTER_NOTIFICATION_CLICK')
                    //   Navigator.of(context).pop();
                    // else {
                    //   Navigator.of(context).pop();
                    //   Navigator.of(context).pop();
                    //   Navigator.of(context).pop();
                    // }
                    // },
                    )
              ],
            ),
          );
        }
        _count++;
      });
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('testonmessageopenapp');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VipC(message)));
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => VipC(message)));
    });

    // _fcm.configure(onMessage: (Map<String, dynamic> message) async {
    //   print('onMessage: $message');
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       content: ListTile(
    //         title: Text(message['notification']['title']),
    //         subtitle: Text(message['notification']['body']),
    //       ),
    //       actions: [
    //         TextButton(
    //           child: Text('ok'),
    //           onPressed: () => Navigator.of(context).pop(),
    //         )
    //       ],
    //     ),
    //   );
    // }, onResume: (Map<String, dynamic> message) async {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => AdminPage()));
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => AdminNotificationView()));
    //   print('on resume $message');
    // }, onLaunch: (Map<String, dynamic> message) async {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => AdminPage()));
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => AdminNotificationView()));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     // ChangeNotifierProvider.value(value: AdminController()),

    //     // ChangeNotifierProvider(
    //     //   create: (context) => AdminController(),
    //     // ),
    //   ],
    //   child:
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (userSnapshot.hasData) {
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
                  return HomeView();
                } else if (user['type'] == 'Advisor') {
                  return HomeView();
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
