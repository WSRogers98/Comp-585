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
import 'package:Cherokee/lobbyJ.dart';
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
      Text("Game Eng"),
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
            String users = "        ";
            String curvote = '                 ';
            String totvote = '                          ';
            var length = snapshot.data.documents.length;
            for (int i = 0; i < length; i++) {
              userName = snapshot.data.documents[i].data['email'];
              votes = snapshot.data.documents[i].data['vote'].toString();
              score = snapshot.data.documents[i].data['score'].toString();
              users = users + userName+"\n"+'        ';
              curvote = curvote + votes+"\n"+"                 ";
              totvote = totvote + score+"\n"+'                          ';
            }
            return buildScore(users, curvote, totvote);
          }),

    ]);
  }
  Widget buildScore(var username, var curvote, var totvote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Final Scores", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 50,
        )),),
        Text("player      total score",style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 20,
        )),),
        Row(
          children: <Widget>[
            Text(username),

            Text(totvote)
          ],
        ),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Column(
                    children: <Widget>[
                      buildS(),
                      RaisedButton(
                          child: Text("Go back to lobby",style: TextStyle(fontSize: 15)),

                          textColor: Colors.white,
                          color: Colors.orangeAccent.withOpacity(0),
                          shape: RoundedRectangleBorder(

                            borderRadius: new BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black54),
                          ),
                          onPressed: () async {
                            if (ownerForEnd){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => lobbyOPage()));
                            }else{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => lobbyJPage()));
                            }
                          })
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

}