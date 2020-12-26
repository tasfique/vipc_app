import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/home_controller.dart';
import 'package:vipc_app/model/member.dart';

class HomeView extends StatefulWidget {
  HomeView({key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends StateMVC {
  _HomeViewState() : super(HomeController()) {
    _con = HomeController.con;
  }

  HomeController _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Ideals'),
      ),
      drawer: Drawer(
        child: Column(children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "Hi, admin",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            accountEmail: Text(
              "admin123@gmail.com",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ]),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                'This is user information',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset(
                  'assets/images/icon1.png',
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset(
                  'assets/images/icon2.png',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset(
                  'assets/images/icon3.png',
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset(
                  'assets/images/icon4.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
