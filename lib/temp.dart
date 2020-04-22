import 'dart:async';
import 'package:Cherokee/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
<<<<<<< HEAD
import 'package:Cherokee/GameScreenA0.dart';
import 'package:Cherokee/main.dart';
=======
import 'package:Cherokee/GameScreenW.dart';
>>>>>>> ruthnew

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

//  String get timeString {
//    Duration duration = controller.duration * controller.value;
//    return '${(duration.inSeconds).toString().padLeft(2, '0')}';
//  }
//
//  AudioCache _audioCache;
  void initState(){
    print("klklkl");
  }

<<<<<<< HEAD
//  @override
//  void initState() {
//    super.initState();
//    _audioCache = AudioCache(
//        prefix: "audio/",
//        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
//    controller = AnimationController(
//      vsync: this,
//      duration: Duration(seconds: 30),
//    );
//
//  }

//  void checkIfOpen() async {
//    var sessionQuery = Firestore.instance
//        .collection('gameSessions')
//        .where('roomNumber', isEqualTo: joinedRoom)
//        .limit(1);
//    var querySnapshot = await sessionQuery.getDocuments();
//    var documents = querySnapshot.documents;
//    var docs =
//        await documents[0].reference.collection("players").getDocuments();
//    var length = docs.documents.length;
//    print("hereeeee1");
//    Firestore.instance
//        .collection('gameSessions')
//        .document(joinedRoom)
//        .updateData({'ask': documents[0].data["ask"] + 1});
//    print("hereeeee2");
//    for (int i = 0; i < length; i++) {
//      Firestore.instance
//          .collection('gameSessions')
//          .document(joinedRoom)
//          .collection("players")
//          .document(docs.documents[i].documentID)
//          .updateData({'vote': 0, 'phrase': null});
//    }
//    print(docs.documents[documents[0].data["ask"]].documentID);
//    print(currUser);
//    print(documents[0].data["ask"]);
//    print("hereeeee");
//    if (documents[0].data["ask"] + 1 >= length) {
//      Firestore.instance
//          .collection('gameSessions')
//          .document(joinedRoom)
//          .updateData({'GameOpen': false});
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => GameEnd()));
//    }
//    if (docs.documents[documents[0].data["ask"] + 1].documentID == currUser) {
//      print(docs.documents[documents[0].data["ask"]].documentID);
//      print(currUser);
//      print("u");
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => MyGame()));
//    } else {
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => AnswerTimer()));
//    }
//  }
=======
  AudioCache _audioCache;

  @override
  void initState() {

  }
>>>>>>> ruthnew



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
<<<<<<< HEAD
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Start the next round", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                          )),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(7.0),
                          ),
                          textColor: Colors.white,
                          elevation: 15,
                          color: thiscolor.withOpacity(1),
                          onPressed: () async {
                            print("ppppppppppppppppppppppppppppppppppppppppppppppppp");
                            var sessionQuery = Firestore.instance
                                .collection('gameSessions')
                                .where('roomNumber', isEqualTo: joinedRoom)
                                .limit(1);
                            var querySnapshot = await sessionQuery.getDocuments();
                            var documents = querySnapshot.documents;
                            var docs = await documents[0].reference.collection("players").getDocuments();
                            for(int i = 0; i < docs.documents.length; i++){
                              var uid = docs.documents[i].documentID;
                              Firestore.instance
                                  .collection('gameSessions')
                                  .document(joinedRoom)
                                  .collection("players")
                                  .document(uid)
                                  .updateData({'phrase': null});
                              Firestore.instance
                                  .collection('gameSessions')
                                  .document(joinedRoom)
                                  .collection("players")
                                  .document(currUser)
                                  .updateData({'vote': null});
                              Firestore.instance
                                  .collection('gameSessions')
                                  .document(joinedRoom)
                                  .collection("players")
                                  .document(currUser)
                                  .updateData({'nextRound': true});
                            }

                            int asknum = documents[0].data['ask'];
                            print(asknum);
                            print("askkkkkk");
                            Firestore.instance
                                .collection('gameSessions')
                                .document(joinedRoom)
                                .updateData({'ask': asknum+1});
                            if(docs.documents[asknum+1].documentID == currUser){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => MyGame()));
                            }else{
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => AnswerTimer()));
                            }

                          })
//                      Positioned.fill(
//                        child: AnimatedBuilder(
//                          animation: controller,
//                          builder: (BuildContext context, Widget child) {
//                            return CustomPaint(
//                                painter: TimerPainter(
//                              animation: controller,
//                              backgroundColor: Colors.white,
//                              color: themeData.indicatorColor,
//                            ));
//                          },
//                        ),
//                      ),
//                      Align(
//                        alignment: FractionalOffset.center,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Text(
//                              "Time Left",
//                              style: themeData.textTheme.subhead,
//                            ),
//                            AnimatedBuilder(
//                                animation: controller,
//                                builder: (BuildContext context, Widget child) {
//                                  return Text(
//                                    timeString,
//                                    style: themeData.textTheme.display4,
//                                  );
//                                }),
//                          ],
//                        ),
//                      ),
                    ],
                  ),
                ),
              ),
            ),
//            Container(
//              margin: EdgeInsets.all(25.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Text(
//                    "Current Phrase Goes Here",
//                  ),
//                ],
//              ),
//            ),

//            Container(
//              child: Align(
//                alignment: Alignment(-.4, 0.9),
//                // Switch register Button
//                child: Form(
//                  // TODO: make a response form for the round?
//                  // key: _formKey,
//
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                            border: OutlineInputBorder(),
//                            hintText: 'Enter a Respose',
//                          ),
//                          autofocus: false,
//                          obscureText: true,
//
//                          // TODO: Change to a response submission
//                          // onSaved: (input) =>
//                          //  _passwordReg = input
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: RaisedButton(
//                          child: Text("Submit"),
//                          onPressed: () {
//                            respond();
//                            _audioCache.play('button.mp3');
//                          },
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ),
          ],
=======
            Text("you are the winner"),
            RaisedButton(
                child: Text("Start the next round", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 15,
                ),
                ),),
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
                  var isAsk = documents[0].data['ask'];
                  print("kkkkkkkkkkkkkkkkkkkkkkkk");
                  if(docs.documents[isAsk].documentID == currUser){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MyGame()));
                  }
                  else{
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MyGame()));
                  }
                }

            )],
>>>>>>> ruthnew
        ),
      ),
    );
  }
}


