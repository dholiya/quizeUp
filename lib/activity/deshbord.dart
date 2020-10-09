import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizup/SessionManager/UserSessionNdata.dart';
import 'package:quizup/TodaysQuiz/TodayQuizUp.dart';
import 'package:quizup/Util/ColorUtil.dart';
import 'package:quizup/auth/Login.dart';

// void main() => runApp(signIn());
class deshbord extends StatelessWidget {
  static String name = "/deshbord";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _deshbord(), // a random number, please don't call xD
    );
  }
}

class _deshbord extends StatefulWidget {
  @override
  _deshbordState createState() => _deshbordState();
}

class _deshbordState extends State<_deshbord> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List userScore = [];
  List alldatawithnumber = [];

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
        body: StreamBuilder(
          stream:
          FirebaseFirestore.instance.collection('dashboard').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    _builditem(context, snapshot.data.documents[index]),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TodayQuizUp()));
              // Navigator.pushNamed(context, TodayQuizUp.name);
            },
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {},
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
      title: Text("Dashboard"),
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

  _builditem(BuildContext context, DocumentSnapshot document) {
    return Card(
      color: Color(ColorUtil.color_Primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              document.id,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(ColorUtil.color_PrimaryLite),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                List keys = [];
                List values = [];
                document.data().forEach((key, value) {
                  if (key == 'total') {
                    keys.add(key);
                    values.add(value.toString());
                  }
                });
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            text: keys[index].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                text: " : " + values[index].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ]),
                      ),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
