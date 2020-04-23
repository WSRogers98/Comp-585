import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:Cherokee/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/GameScreenW.dart';
import 'package:Cherokee/main.dart';
import 'package:google_fonts/google_fonts.dart';
// TODO: get timer to automatically start
//done
void main() => runApp(GameEnd());

class GameEnd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<GamePage> with TickerProviderStateMixin {
  @override
  AnimationController controller;

  @override
  void initState() {

  }

  Widget buildS() {
    return Column(children: <Widget>[
      Text("Final Score"),
      StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('gameSessions')
              .document(joinedRoom)
              .collection('players')
              .snapshots(),
          builder: (context, snapshot) {
            var userName;
            var votes;
            var score;
            String scoreBoard = '';
            var length = snapshot.data.documents.length;
            for (int i = 0; i < length; i++) {
              userName = snapshot.data.documents[i].documentID;
              votes = snapshot.data.documents[i].data['vote'].toString();
              score = snapshot.data.documents[i].data['score'].toString();
              scoreBoard = scoreBoard +
                  "\n" +
                  userName +
                  "\n" +
                  "current round: " +
                  votes +
                  "\n" +
                  "total score: " +
                  score;
            }
            return Text(scoreBoard);
          }),

    ]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    const thiscolor = const Color(0x6BA7B5);
    return buildS();
  }
}
