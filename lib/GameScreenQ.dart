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
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
int ask;
String _question;
final myController = TextEditingController();
void findAsk() async {
  //this code is to periodically check if GameOpen has been set to true by the room owner, if it is true
  //then move them to gamescreen
  var sessionQuery = Firestore.instance
      .collection('gameSessions')
      .where('roomNumber', isEqualTo: joinedRoom)
      .limit(1);
  var querySnapshot = await sessionQuery.getDocuments();
  var documents = querySnapshot.documents;
  if (documents.length == 0) { /*room doesn't exist? */ return; }
  var isGameOpen = documents[0].data['GameOpen'];
  ask = documents[0].data['ask'];
}
void main() => runApp(MyGame());

class MyGame extends StatelessWidget {
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

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    if (ind){
      Firestore.instance
          .collection('gameSessions')
          .document(joinedRoom)
          .collection("players")
          .document(currUser)
          .updateData({'nextRound': false});
      ind = false;
    }
  }

<<<<<<< HEAD


  Widget buildQ() {
    ThemeData themeData = Theme.of(context);
    const thiscolor = const Color(0x6BA7B5);
    startTimer(controller);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: FractionalOffset.center,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return CustomPaint(
                            painter: TimerPainter(
                              animation: controller,
                              backgroundColor: Colors.white,
                              color: themeData.indicatorColor,
                            ));
                      },
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Time Left",
                          style: GoogleFonts.bubblegumSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
=======
  Widget buildI() {
    return Text("Qwait for the winner to start next round");
  }

  Widget buildQ(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    const thiscolor = const Color(0x6BA7B5);
    startTimer(controller);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: themeData.indicatorColor,
                                ));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Time Left",
                              style: GoogleFonts.bubblegumSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30,
                                ),
                              ),
>>>>>>> ruthnew
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return Text(
                                timeString,
                                style: GoogleFonts.bubblegumSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    letterSpacing: 0.0,
                                    fontSize: 112,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          child: Align(
            alignment: Alignment(-.4, 0.9),
            // Switch register Button
            child: Form(
              // TODO: make a response form for the round?
              // key: _formKey,

<<<<<<< HEAD
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: myController,
                      style: GoogleFonts.bubblegumSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          )),
                      decoration: new InputDecoration(
                        labelText: "Enter Your Question Here!",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          borderSide: new BorderSide(),
=======
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                            border: OutlineInputBorder(),
//                            hintText: 'Enter a Respose',
//                          ),
//                          autofocus: false,
//                          // TODO: Change to a response submission
//                          onSaved: (input) => _question = input
//                        ),
                        child: TextField(
                          controller: myController,
                          style: GoogleFonts.bubblegumSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              )),
                          decoration: new InputDecoration(
                            labelText: "Enter Your Question Here!",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
>>>>>>> ruthnew
                        ),
                        //fillColor: Colors.green
                      ),
<<<<<<< HEAD
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: GoogleFonts.bubblegumSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            )),
                      ),
                      onPressed: () async {
                        Firestore.instance
                            .collection('gameSessions')
                            .document(joinedRoom)
                            .collection('players')
                            .document(currUser)
                            .updateData({
                          'phrase': myController.text,
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WaitTimer()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(7.0),
                      ),
                      textColor: Colors.white,
                      elevation: 15,
                      color: thiscolor.withOpacity(1),
                    ),
                  )
                ],
=======
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text(
                            "Submit",
                            style: GoogleFonts.bubblegumSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                )),
                          ),
                          onPressed: () async {
                            Firestore.instance
                                .collection('gameSessions')
                                .document(joinedRoom)
                                .collection('players')
                                .document(currUser)
                                .updateData({
                              'phrase': myController.text,
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WaitTimer()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(7.0),
                          ),
                          textColor: Colors.white,
                          elevation: 15,
                          color: thiscolor.withOpacity(1),
                        ),
                      )
                    ],
                  ),
                ),
>>>>>>> ruthnew
              ),
            ),
          ),
        ),
      ],
    );
  }
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child:
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('gameSessions').document(
                          joinedRoom).collection('players').document(currUser).snapshots(),
                      builder: (context, snapshot) {
//                        String question = snapshot.data.documents[ask].data['phrase'];
//                        var length = snapshot.data.documents.length;

                        var nextRound = snapshot.data['nextRound'];
                        print(nextRound);
                        print("yyyyyy");
                        return buildQ();

                        return Text("");
                      }
                  ),
                )
              ],
              )
    ));}
}
=======
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    const thiscolor = const Color(0x6BA7B5);
    startTimer(controller);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                child:
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection(
                        'gameSessions')
                        .document(joinedRoom)
                        .collection('players')
                        .snapshots(),
                    builder: (context, snapshot) {
                      var totVote = 0;
                      bool ready = true;
                      String question = snapshot.data.documents[0]
                          .data['phrase'];
                      var length = snapshot.data.documents.length;
                      for (int i = 0; i < length; i++) {
                        if (snapshot.data.documents[i]
                            .data['phrase'] == null) {
                          ready = false;
                        }
                        totVote = totVote +
                            snapshot.data.documents[i].data['vote'];
                      }
                      var currI;
                      for (int i = 0; i < length; i++) {
                        if (currUser ==
                            snapshot.data.documents[i].documentID) {
                          currI = i;
                        }
                      }
                      var nextRound = snapshot.data.documents[currI]
                          .data['nextRound'];
                      if (nextRound == false) {
                        return buildI();
                      }
                      return buildQ(context);
                    }
                )

            )

          ],
        ),
      ),
    );
  }
  }


>>>>>>> ruthnew


void startTimer(controller) {
  controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
}

  class TimerPainter extends CustomPainter {
  TimerPainter({
  this.animation,
  this.backgroundColor,
  this.color,
  }) : super(repaint: animation);
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
  Paint paint = Paint()
  ..color = backgroundColor
  ..strokeWidth = 5
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;
  canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
  paint.color = color;
  double progress = (1.0 - animation.value) * 2 * math.pi;
  canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
  // TODO: implement repaint
  return animation.value != old.animation.value ||
  color != old.color ||
  backgroundColor != old.backgroundColor;
  }
  }


