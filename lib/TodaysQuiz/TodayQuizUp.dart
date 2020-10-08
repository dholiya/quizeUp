import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:quizup/TodaysQuiz/model/model_todayquize.dart';
import 'package:quizup/Util/ColorUtil.dart';
import 'package:quizup/activity/home.dart';
import 'package:http/http.dart' as http;
import 'package:quizup/Util/util.dart';

class TodayQuizUp extends StatelessWidget {
  static String name = "/TodayQuizUp";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today\'s Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _todayQuizUp(), // a random number, please don't call xD
    );
  }
}

class _todayQuizUp extends StatefulWidget {
  @override
  _todayQuizUpState createState() => _todayQuizUpState();
}

class _todayQuizUpState extends State<_todayQuizUp> {
  DatabaseReference ref =
      FirebaseDatabase.instance.reference().child('questions');
  var lists;
  PageController pageController = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var currentPageValue = 0.0;
  var gradients = getGradients();
  var totalQuestions = 0;
  int correctIndex;
  int choiseIndex = 10;
  bool trufalseCheck = false;
  bool submitClicked = false;
  int leadBtnColor = ColorUtil.color_Primary;
  int Score = 0;
  bool visibility = true;

  @override
  initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: _appBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: visibility,
              child: Card(
                color: Color(ColorUtil.color_Primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Question ${currentPageValue.toInt() + 1}/${totalQuestions}",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                          padding: EdgeInsets.all(7),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: "Score : ",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "$Score",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))
                                  ]),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: FutureBuilder<List<model_todayquize>>(
                    future: readFutureData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<model_todayquize> allData = snapshot.data;
                      if (snapshot.hasData) {
                        return PageView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            controller: pageController,
                            itemCount: totalQuestions = allData.length,
                            itemBuilder: (BuildContext context, int position) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Stack(
                                  children: [
                                    Transform(
                                      transform: Matrix4.identity()
                                        ..rotateX(currentPageValue - position),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            _question(
                                                allData[position].question),
                                            _answers(allData[position].answers,
                                                allData[position].correctIndex)
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            gradient: gradients[
                                                position % gradients.length],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
            Visibility(
              visible: visibility,
              child: Card(
                color: Color(ColorUtil.color_Primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (submitClicked) {
                                _displaySnackBar(context, "Already checked");
                              } else if (choiseIndex == 10) {
                                submitClicked = false;
                                _displaySnackBar(
                                    context, "Please select option");
                              } else if (correctIndex == choiseIndex) {
                                trufalseCheck = true;
                                print("SUBMIT true");
                                submitClicked = true;
                                Score++;
                                leadBtnColor = 0xFF32CD32;
                              } else {
                                print("SUBMIT false");
                                submitClicked = true;
                                leadBtnColor = 0xFFDC143C;
                                trufalseCheck = false;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 3,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "CHECK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (choiseIndex == 10) {
                                _displaySnackBar(
                                    context, "Please select option");
                              } else if (!submitClicked) {
                                _displaySnackBar(context, "Click on Check");
                              } else if (currentPageValue.toInt() ==
                                  totalQuestions - 1) {
                                _displaySnackBar(
                                    context, "End of Today's Quiz");
                              } else if (pageController.hasClients) {
                                choiseIndex = 10;
                                submitClicked = false;
                                pageController.animateToPage(
                                  currentPageValue.toInt() + 1,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 3,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "NEXT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//local
  Future<String> _loadAStudentAsset() async {
    return await rootBundle.loadString('assets/abc.json');
  }

//
  Future<List<model_todayquize>> readFutureData() async {
    List<model_todayquize> list;

    String jsonString = await _loadAStudentAsset();
    var data = json.decode(jsonString);
    var rest = data as List;
    list = rest
        .map<model_todayquize>((json) => model_todayquize.fromJson(json))
        .toList();

    setState(() {
      totalQuestions = list.length;
    });
    return list;
  }

  //server
  // Future<List<model_todayquize>> readFutureData() async {
  //   List<model_todayquize> list;
  //
  //   var result = await http.get(UtilData.LINK_DAILY);
  //   var data = json.decode(result.body);
  //   var rest = data as List;
  //   list = rest
  //       .map<model_todayquize>((json) => model_todayquize.fromJson(json))
  //       .toList();
  //
  //   setState(() {
  //     totalQuestions = list.length;
  //   });
  //   return list;
  // }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
      title: Text(
        "Today\'s Quiz",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _question(data) {
    return Container(
      child: Text(
        data,
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
      ),
    );
  }

  _answers(data, int correctIndex) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (!submitClicked) {
                setState(() {
                  leadBtnColor = ColorUtil.color_Primary;
                  this.correctIndex = correctIndex;
                  choiseIndex = index;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0x33000000),
                    style: BorderStyle.solid,
                    width: 3,
                  ),
                  color: Color(0x55000000),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 3),
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: choiseIndex == index
                            ? Colors.white
                            : Colors.transparent,
                        child: Icon(
                          Icons.check_circle,
                          size: 26.0,
                          color: choiseIndex == index
                              ? Color(leadBtnColor)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    Text(
                      data[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _displaySnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(
      content: Text(s),
      duration: Duration(milliseconds: 600),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static getGradients() {
    return [
      LinearGradient(
        colors: [
          Color(0xffffafbd),
          Color(0xffffc3a0),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0xdd2193b0),
          Color(0xdd6dd5ed),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0xbb753a88),
          Color(0xbbcc2b5e),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0x992c3e50),
          Color(0xffbdc3c7),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0xffde6262),
          Color(0xffffb88c),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0xff56ab2f),
          Color(0xcca8e063),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0xbb614385),
          Color(0x66516395),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      LinearGradient(
        colors: [
          Color(0x8861045f),
          Color(0x55aa076b),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
    ];
  }
}
