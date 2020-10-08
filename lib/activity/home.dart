import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizup/TodaysQuiz/TodayQuizUp.dart';
import 'package:quizup/Util/ColorUtil.dart';

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
        drawer: _drawer(),
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
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: Text("Home"),
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

  void funtion() {
    userScore.clear();
    alldatawithnumber.clear();

    FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;



    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("dashboard").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map hashMap = new Map<String, dynamic>.from(result.data());
        hashMap.forEach((key, value) {
          var tempscore = {
            "\"" + key + "\"": value,
          };
          userScore.add(tempscore);
        });
        alldatawithnumber.add({"\"" + result.id + "\"": userScore});
      });
      print("dashboard ${alldatawithnumber}");
    });
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
            color: Color(ColorUtil.color_PrimaryLite),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: document.data().length,
              itemBuilder: (BuildContext context, int index) {
                List keys = [];
                List values = [];
                document.data().forEach((key, value) {
                  keys.add(key);
                  values.add(value.toString());
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
                                  text: " : "+values[index].toString(),
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
