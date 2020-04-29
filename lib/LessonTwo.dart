import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Cherokee/main.dart';
import 'package:Cherokee/SizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Cherokee/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:Cherokee/LearnMenu.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
//wat
var finalScore = 0;
var questionNumber = 0;
var quiz = new CherokeeQuiz();

class CherokeeQuiz {
  var questions = [
    //
    "TV",
    //
    "fart",
    //
    "ᎤᏛᏐᏅ",
    //
    "ᎠᏣᏗ",
  ];

  var choices = [
    //
    ["ᎠᏓᏴᎳᏘᏍᎩ", "ᎠᏣᏗ", "ᎠᏌᎩᏍᏗ", "ᎤᏛᏐᏅ"],
    //
    ["ᎠᏌᎩᏍᏗ", "ᎤᏛᏐᏅ", "ᎠᏓᏴᎳᏘᏍᎩ", "ᎠᏣᏗ"],
    //
    ["TV", "fart", "fish", "old man"],
    //
    ["old man", "fish", "TV", "fart"],
    //

  ];

  var correctAnswers = ["ᎠᏓᏴᎳᏘᏍᎩ", "ᎠᏌᎩᏍᏗ", "old man", "fish"];
}

class LessonTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = const Color(0xffb77b);
    const buttoncolor = const Color(0x6BA7B5);
    const themeColor = const Color(0xffb77b);
    return new MaterialApp(
      title: 'Cherokee Learning Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: themeColor.withOpacity(1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.pinkAccent,
        buttonTheme: ButtonThemeData(
          height: 25,
          minWidth: 65,
        ),
      ),
      home: new GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _MyLearnPageState createState() => new _MyLearnPageState();
}

class _MyLearnPageState extends State<GamePage> with TickerProviderStateMixin {
  @override
  AnimationController controller;

  AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(
        prefix: "audio/",
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = const Color(0xffb77b);
    const buttoncolor = const Color(0x6BA7B5);
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: new Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(20.0)),

                new Container(
                  alignment: Alignment.centerRight,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "ᎠᏛᏓᏍᏗ ${questionNumber + 1} of ${quiz.questions.length}",
                        style: new TextStyle(fontSize: 22.0),
                      ),
                      new Text(
                        "ᎦᏅᎥᎬ: $finalScore",
                        style: new TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                ),

                //image
                new Padding(padding: EdgeInsets.all(10.0)),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Text(
                  quiz.questions[questionNumber],
                  style: new TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold),
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //button 1
                    new MaterialButton(
                      minWidth: 120.0,
                      color: buttoncolor.withOpacity(1),
                      onPressed: () {
                        _audioCache.play('button.mp3');
                        if (quiz.choices[questionNumber][0] ==
                            quiz.correctAnswers[questionNumber]) {
                          Fluttertoast.showToast(
                              msg: "Correct",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          finalScore++;
                        } else {
                          Fluttertoast.showToast(
                              msg: "Wrong",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][0],
                        style:
                        new TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),

                    //button 2
                    new MaterialButton(
                      minWidth: 120.0,
                      color: buttoncolor.withOpacity(1),
                      onPressed: () {
                        _audioCache.play('button.mp3');
                        if (quiz.choices[questionNumber][1] ==
                            quiz.correctAnswers[questionNumber]) {
                          Fluttertoast.showToast(
                              msg: "Correct",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          finalScore++;
                        } else {
                          Fluttertoast.showToast(
                              msg: "Wrong",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][1],
                        style:
                        new TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //button 3
                    new MaterialButton(
                      minWidth: 120.0,
                      color: buttoncolor.withOpacity(1),
                      onPressed: () {
                        _audioCache.play('button.mp3');
                        if (quiz.choices[questionNumber][2] ==
                            quiz.correctAnswers[questionNumber]) {
                          Fluttertoast.showToast(
                              msg: "Correct",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          finalScore++;
                        } else {
                          Fluttertoast.showToast(
                              msg: "Wrong",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][2],
                        style:
                        new TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),

                    //button 4
                    new MaterialButton(
                      minWidth: 120.0,
                      color: buttoncolor.withOpacity(1),
                      onPressed: () {
                        _audioCache.play('button.mp3');
                        if (quiz.choices[questionNumber][3] ==
                            quiz.correctAnswers[questionNumber]) {
                          Fluttertoast.showToast(
                              msg: "Correct",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          finalScore++;
                        } else {
                          Fluttertoast.showToast(
                              msg: "Wrong",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        updateQuestion();
                      },
                      child: new Text(
                        quiz.choices[questionNumber][3],
                        style:
                        new TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                new Padding(padding: EdgeInsets.all(15.0)),

                new Container(
                    alignment: Alignment.bottomCenter,
                    child: new MaterialButton(
                        minWidth: 240.0,
                        height: 30.0,
                        color: Colors.red,
                        onPressed: () {
                          _audioCache.play('button.mp3');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondRoute()),
                          );
                        },
                        child: new Text(
                          "ᎦᏅᎪᎢᏍᏗ",
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ))),
              ],
            ),
          ),
        ));
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == quiz.questions.length - 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(
                  score: finalScore,
                )));
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatelessWidget {
  final int score;

  Summary({Key key, @required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "ᎣᏂ ᏚᏂᎾ: $score",
                style: new TextStyle(fontSize: 35.0),
              ),
              new Padding(padding: EdgeInsets.all(30.0)),
              Row(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(30.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          questionNumber = 0;
                          finalScore = 0;
                          Navigator.pop(context);
                        },
                        child: new Text(
                          "ᏥᎭᏂᎩᏍᏓ",
                          style: new TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  new Padding(padding: EdgeInsets.all(40.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          questionNumber = 0;
                          finalScore = 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  SecondRoute()),
                          );
                        },
                        child: new Text(
                          "ᎦᏅᎪᎢᏍᏗ",
                          style: new TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
