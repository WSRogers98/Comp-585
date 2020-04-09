import 'dart:async';
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
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:Cherokee/main.dart';
import 'package:Cherokee/GameScreenQ.dart';
import 'package:Cherokee/GameScreenEnd.dart';
import 'package:Cherokee/temp.dart';
import 'package:Cherokee/GameScreenA0.dart';

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
    super.initState();
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    checkIfOpen();
  }

  void checkIfOpen() async{
    var sessionQuery = Firestore.instance
        .collection('gameSessions')
        .where('roomNumber', isEqualTo: joinedRoom)
        .limit(1);
    var querySnapshot = await sessionQuery.getDocuments();
    var documents = querySnapshot.documents;
    var docs = await documents[0].reference.collection("players").getDocuments();
    var length = docs.documents.length;
    print("hereeeee1");
    Firestore.instance
        .collection('gameSessions')
        .document(joinedRoom)
        .updateData({'ask': documents[0].data["ask"] + 1});
    print("hereeeee2");
    for(int i = 0; i < length; i++){
      Firestore.instance
          .collection('gameSessions')
          .document(joinedRoom)
          .collection("players")
          .document(docs.documents[i].documentID)
          .updateData({'vote': 0, 'phrase': null});
    }
    print(docs.documents[documents[0].data["ask"]].documentID);
    print(currUser);
    print(documents[0].data["ask"]);
    print("hereeeee");
    if(documents[0].data["ask"]+1 >= length){
      Firestore.instance
          .collection('gameSessions')
          .document(joinedRoom)
          .updateData({'GameOpen': false});
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GameEnd()));
    }
    if(docs.documents[documents[0].data["ask"]+1].documentID==currUser){
      print(docs.documents[documents[0].data["ask"]].documentID);
      print(currUser);
      print("u");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyGame()));
    }else{
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AnswerTimer()));
    }
  }


  @override
  Widget build(BuildContext context) {
    startTimer(controller);
    ThemeData themeData = Theme.of(context);
    const thiscolor = const Color(0x6BA7B5);
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Time Left",
                              style: themeData.textTheme.subhead,
                            ),
                            AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  return Text(
                                    timeString,
                                    style: themeData.textTheme.display4,
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
              margin: EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Current Phrase Goes Here",

                  ),
                ],
              ),
            ),


//            Container(
//              margin: EdgeInsets.all(8.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  FloatingActionButton(
//                    child: AnimatedBuilder(
//                      animation: controller,
//                      builder: (BuildContext context, Widget child) {
//                        return Icon(controller.isAnimating
//                            ? Icons.pause
//                            : Icons.play_arrow);
//
//                        // Icon(isPlaying
//                        // ? Icons.pause
//                        // : Icons.play_arrow);
//                      },
//                    ),
//                    onPressed: () {
//                      // setState(() => isPlaying = !isPlaying);
//
//                      if (controller.isAnimating) {
//                        controller.stop(canceled: true);
//                      } else {
//                        controller.reverse(
//                            from: controller.value == 0.0
//                                ? 1.0
//                                : controller.value);
//                      }
//                    },
//                  )
//                ],
//              ),
//            )
            Container(
              child: Align(
                alignment: Alignment(-.4, 0.9),
                // Switch register Button
                child: Form(

                  // TODO: make a response form for the round?
                  // key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a Respose',
                          ),
                          autofocus: false,
                          obscureText: true,

                          // TODO: Change to a response submission
                          // onSaved: (input) =>
                          //  _passwordReg = input

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: (){respond();
                          _audioCache.play('button.mp3');
                          },
                        ),
                      )
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

void respond() async{}