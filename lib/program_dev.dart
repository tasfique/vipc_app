import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vipc_app/controller/news/admin_controller.dart';
import 'package:vipc_app/view/admin/admin_home.dart';
import 'package:vipc_app/view/home/home_view.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vipc_app/view/splash/splash_view.dart';

void main() async {
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
        home: VipC());
  }
}

class VipC extends StatelessWidget {
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
