import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizup/SessionManager/UserSessionNdata.dart';
import 'package:quizup/TodaysQuiz/TodayQuizUp.dart';
import 'package:quizup/Util/ColorUtil.dart';
import 'package:quizup/auth/Login.dart';

import 'deshbord.dart';

// void main() => runApp(signIn());
class home extends StatelessWidget {
  static String name = "/home";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _home(), // a random number, please don't call xD
    );
  }
}

class _home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<_home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        drawer: _drawer(),
        body: Container(
        ),
      ),
    );
  }

  _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _header(),
          ListTile(
            title: Text('Today\'s QuizUp'),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => TodayQuizUp()));
              Navigator.pushNamed(context, TodayQuizUp.name);
            },
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              setState(() {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new deshbord()));
              });
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Session prefs = Session();
              prefs.setAuthToken(false);
              prefs.setmoNumber("");
              prefs.setName("");
              setState(() {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Login()));
              });
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: Text("QuizUp"),
      leading: new IconButton(
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        icon: new Icon(Icons.menu),
      ),
      backgroundColor: Colors.blue.shade500,
    );
  }

  _header() {
    return DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/logo/app_icon.png"),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 70,
              ),
              SizedBox(
                  child: Text("QuizUp",
                      style: TextStyle(color: Colors.blue, fontSize: 36))),
            ],
          ),
        ));
  }

}
