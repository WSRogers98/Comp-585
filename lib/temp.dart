import 'dart:async';
import 'package:Cherokee/GameScreenA0.dart';
import 'package:Cherokee/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/GameScreenQ.dart';
import 'package:Cherokee/GameScreenEnd.dart';
import 'package:Cherokee/temp.dart';
import 'package:Cherokee/GameScreenW.dart';

// TODO: get timer to automatically start
//done
void main() => runApp(temp());

class temp extends StatelessWidget {
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

  String get timeString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inSeconds).toString().padLeft(2, '0')}';
  }

  AudioCache _audioCache;

  @override
  void initState() {

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You are the winner!🎉",style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 40,
            )),),
        Container(margin: const EdgeInsets.only(bottom: 30.0),
          child:
            RaisedButton(
                child: Text("Start the next round", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 25,
                ),
                ),),
                color: Colors.teal,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(7.0),
                ),
                textColor: Colors.white,
                elevation: 15,
                //color: thiscolor.withOpacity(1),
                onPressed: () async {
                  var sessionQuery = Firestore.instance
                      .collection('gameSessions')
                      .where('roomNumber', isEqualTo: joinedRoom)
                      .limit(1);
                  var querySnapshot = await sessionQuery.getDocuments();
                  var documents = querySnapshot.documents;
                  var docs = await documents[0].reference.collection("players")
                      .getDocuments();
                  var length = docs.documents.length;
                  var isAsk = documents[0].data['ask'];
                  Firestore.instance
                      .collection('gameSessions')
                      .document(joinedRoom)
                      .updateData({'ask': documents[0].data["ask"] + 1});
                  for (int i = 0; i < length; i++) {
                    Firestore.instance
                        .collection('gameSessions')
                        .document(joinedRoom)
                        .collection('players')
                        .document(docs.documents[i].documentID)
                        .updateData(
                        {'vote': 0, 'phrase': null, 'nextRound': true});
                  }
                  ind = false;
                  if(isAsk+1 == length){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => GameEnd()));
                  }
                  else if(docs.documents[isAsk+1].documentID == currUser){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MyGame()));
                  }
                  else{
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AnswerTimer()));
                  }
                }

            ))],
        ),
      ),
    );
  }
}
