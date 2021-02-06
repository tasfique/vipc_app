import 'package:flutter/material.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends StateMVC<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginView())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.brown[500],
            Colors.brown[700],
            Colors.brown[900],
            Colors.brown[700],
            Colors.brown[500],
          ],
        ),
      ),
      child: Image.asset(
        "assets/images/logo.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
