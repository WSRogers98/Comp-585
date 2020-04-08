import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test8/lobbyO.dart';
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
import 'package:test8/FirstScreen.dart';
import 'package:test8/GameScreenQ.dart';
import 'package:test8/GameScreenEnd.dart';
import 'package:test8/temp.dart';
import 'package:test8/GameScreenA0.dart';
// TODO: get timer to automatically start
//done
int ask;
void main() => runApp(WaitTimer());

class WaitTimer extends StatelessWidget {
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
    findAsk();
  }

  void findAsk() async{
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

  Widget buildScore(var scoreBoard){
    return Column(
      children: <Widget>[
        Text(scoreBoard),

      ],
    );
  }

  Widget buildS(){
    return Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('gameSessions').document(joinedRoom).collection('players').snapshots(),
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
                  scoreBoard = scoreBoard + "\n"+userName + "\n" + "current round: " + votes + "\n" + "total score: " + score;
                }
                return Text(scoreBoard);
              }
          ),
          RaisedButton(
              child: Text("Go to the next round"),
              onPressed: () async {
                Navigator.push(
                      context, MaterialPageRoute(builder: (context) => temp()));
//                var sessionQuery = Firestore.instance
//                    .collection('gameSessions')
//                    .where('roomNumber', isEqualTo: joinedRoom)
//                    .limit(1);
//                var querySnapshot = await sessionQuery.getDocuments();
//                var documents = querySnapshot.documents;
//                var docs = await documents[0].reference.collection("players").getDocuments();
//                var length = docs.documents.length;
//                print("hereeeee1");
//                Firestore.instance
//                    .collection('gameSessions')
//                    .document(joinedRoom)
//                    .updateData({'ask': documents[0].data["ask"] + 1});
//                print("hereeeee2");
////              for(int i = 0; i < length; i++){
////                Firestore.instance
////                    .collection('gameSessions')
////                    .document(joinedRoom)
////                    .collection("players")
////                    .document(docs.documents[i].documentID)
////                    .updateData({'vote': 0, 'phrase': null});
////              }
//                print(docs.documents[documents[0].data["ask"]].documentID);
//                print(currUser);
//                print(documents[0].data["ask"]);
//                print("hereeeee");
//                if(documents[0].data["ask"]+1 >= length){
//                  Firestore.instance
//                      .collection('gameSessions')
//                      .document(joinedRoom)
//                      .updateData({'GameOpen': false});
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => GameEnd()));
//                }
//                if(docs.documents[documents[0].data["ask"]+1].documentID==currUser){
//                  print(docs.documents[documents[0].data["ask"]].documentID);
//                  print(currUser);
//                  print("u");
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => MyGame()));
//                }else{
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => AnswerTimer()));
//                }
              })
        ]
    );
  }

  Widget buildV(BuildContext context, String question){
    return Scaffold(
        body:
        Column(children: <Widget>[
          Text(question),
          Flexible(child: _buildBody(context),),
        ],)
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('gameSessions').document(joinedRoom).collection("players").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.phrase),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

      child: _buttonEnable(data),

    );
  }

  Widget _buttonEnable(DocumentSnapshot data){
    final record = Record.fromSnapshot(data);
    print("pray");
    print(record.reference.documentID);
    print(askUID);
    print(currUser);
    if(record.reference.documentID != askUID){
      if(record.reference.documentID != currUser){
        return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(record.phrase),
              onTap: () {
                record.reference.updateData({'vote': FieldValue.increment(1)});
                record.reference.updateData({'score': FieldValue.increment(1)});


              },
            )
        );
      }
    }
    return Text('');
  }
  Widget _buttonDisable(DocumentSnapshot data){
    final record = Record.fromSnapshot(data);
    return ListTile(
      title: Text(record.phrase),
    );
  }

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
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance.collection('gameSessions').document(joinedRoom).collection('players').snapshots(),
                          builder: (context, snapshot) {
                            var totVote = 0;
                            bool ready = true;
                            String question = snapshot.data.documents[ask].data['phrase'];
                            var length = snapshot.data.documents.length;
                            for (int i = 0; i < length; i++) {
                              if (snapshot.data.documents[i].data['phrase'] == null) {
                                ready = false;
                              }

                              totVote = totVote + snapshot.data.documents[i].data['vote'];
                            }
                            if(totVote==length){
                              return buildS();
                            }
                            if (ready == true) {
                              return buildV(context, question);
                            }
                            return buildWait(context);
                          }
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

  @override
  Widget buildWait(BuildContext context) {
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
//
          Text("Just wait"),


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
class Record {
  final String phrase;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['phrase'] != null),
        assert(map['vote'] != null),
        phrase = map['phrase'],
        votes = map['vote'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$phrase:$votes>";
}