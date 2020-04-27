import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:Cherokee/main.dart';
import 'package:Cherokee/GameScreenQ.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/GameScreenEnd.dart';
import 'package:Cherokee/GameScreenW.dart';
import 'package:Cherokee/temp.dart';
String prompt = "Enter your answer:";
bool ignore = false;
int memNum;
final myController = TextEditingController();
// TODO: get timer to automatically start
void main() => runApp(AnswerTimer());
int ask;
var askUID;
class AnswerTimer extends StatelessWidget {
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
          height: 35,
          minWidth: 120,
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
      duration: Duration(seconds: 45),
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
    //findAsk();
  }

  Widget buildV(BuildContext context, String question){
    return Scaffold(
        body:
        Column(children: <Widget>[
          Text(question, style: GoogleFonts.bubblegumSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),),
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

                Fluttertoast.showToast(
                    msg: "You Voted",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 10,
                    backgroundColor: Colors.black26,
                    textColor: Colors.white,
                    fontSize: 16.0);

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



  Widget buildS(){
    const thiscolor = const Color(0x6BA7B5);
    return Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('gameSessions').document(joinedRoom).collection('players').snapshots(),
              builder: (context, snapshot) {
                String users = "        ";
                String curvote = '                 ';
                String totvote = '                          ';
                var userName;
                var votes;
                var score;
                String scoreBoard = '';
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
              }
          ),
          RaisedButton(
              child: Text("Go to the next round",style: TextStyle(fontSize: 15)),
              textColor: Colors.white,
              color: Colors.black54.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.black54),
              ),



              onPressed: () async {
                var sessionQuery = Firestore.instance
                    .collection('gameSessions')
                    .where('roomNumber', isEqualTo: joinedRoom)
                    .limit(1);
                var querySnapshot = await sessionQuery.getDocuments();
                var documents = querySnapshot.documents;
                var docs = await documents[0].reference.collection("players").getDocuments();
                var length = docs.documents.length;

                var isGameOpen = documents[0].data['GameOpen'];
                var isAsk = documents[0].data['ask'];

//            var firstUser = docs.documents[documents[0].data['ask']].documentID;
                var hiVote = 0;
                var hiVoteUser;
                if(documents[0].data["ask"]+1 >= length){
                  Firestore.instance
                      .collection('gameSessions')
                      .document(joinedRoom)
                      .updateData({'GameOpen': false});
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => GameEnd()));
                }
                for(int i = 0; i < length; i++){
                  if(hiVote < docs.documents[i].data["vote"]){
                    hiVote = docs.documents[i].data["vote"];
                    hiVoteUser = docs.documents[i].documentID;
                  }
                }
                if (hiVoteUser == currUser){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => temp()));
                }
                else{
                  if (docs.documents[isAsk+1].documentID == currUser){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MyGame()));
                    ind=true;
                  }
                  else{
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AnswerTimer()));
                    ind=true;
                  }
                }

              })
        ]
    );
  }
  Widget buildI(){
    return Text("Wait for the winner to start next round...",style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
      fontWeight: FontWeight.w100,
      fontSize: 50,
    )),);
  }

  Widget buildScore(var username, var curvote, var totvote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Leaderboard", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 50,
        )),),
        Text("player      current round      total score",style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 20,
        )),),
        Row(
          children: <Widget>[
            Text(username),
            Text(curvote),
            Text(totvote)
          ],
        ),
      ],
    );
  }

  Widget buildW(){
    return Column(
        children: <Widget>[
          Text("Waiting for others to answer...", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 15,
          )),),
        ]
    );
  }

  Widget buildN(var question){
    const thiscolor = const Color(0x6BA7B5);
    return Column(
        children: <Widget>[
          Text(question,style: GoogleFonts.bubblegumSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),),
          Text(prompt,style: GoogleFonts.bubblegumSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),),
          TextField(
            controller: myController,
          ),
          RaisedButton(
              child: Text("ᏫᎲᎦ", style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 15,
              ),
              ),),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(7.0),
              ),
              textColor: Colors.white,
              elevation: 15,
              color: thiscolor.withOpacity(1),
              onPressed: () async {
                Firestore.instance
                    .collection('gameSessions')
                    .document(joinedRoom)
                    .collection('players')
                    .document(currUser)
                    .updateData({
                  'phrase': myController.text,
                });
              })
        ]
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
                  child: Stack(
                    children: <Widget>[
                      StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance.collection('gameSessions').document(joinedRoom).snapshots(),
                        builder: (context, snapshot) {
                          ask = snapshot.data["ask"];
                          return streamBuilder(ask);
                        },
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
  Widget streamBuilder(int ask){
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('gameSessions').document(joinedRoom).collection('players').snapshots(),
        builder: (context, snapshot) {
          var totVote = 0;
          bool ready = true;

          String question = snapshot.data.documents[ask].data['phrase'];
          var length = snapshot.data.documents.length;
          askUID = snapshot.data.documents[ask].documentID;
          for (int i = 0; i < length; i++) {
            if (snapshot.data.documents[i].data['phrase'] == null) {
              ready = false;
            }
            totVote = totVote + snapshot.data.documents[i].data['vote'];
          }
          var currI;
          for(int i = 0; i < length; i++){
            if(currUser == snapshot.data.documents[i].documentID){
              currI = i;
            }
          }
          var nextRound = snapshot.data.documents[currI].data['nextRound'];
          if(nextRound==false){
            return buildI();
          }
          if(totVote==length){
            return buildS();
          }
          if (ready == true) {
            return buildV(context, question);
          }
          return buildA(context);
        }
    );
  }


  Widget buildA(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    startTimer(controller);
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "ᎤᏓᎷᎳ",
                              style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 30,
                              ),
                              ),
                            ),
                            AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  return Text(
                                    timeString,
                                    style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      letterSpacing: 0.0,
                                      fontSize: 112,
                                    ),
                                    ),
                                  );
                                }),
                            ///////////////////////////////
                            StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance.collection('gameSessions').document(joinedRoom).snapshots(),
                              builder: (context, snapshot) {
                                ask = snapshot.data["ask"];
                                return Text("");

                              },
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance.collection('gameSessions').document(joinedRoom).collection('players').snapshots(),
                              builder: (context, snapshot) {
                                var length = snapshot.data.documents.length;
                                for(int i = 0; i < length; i++){
                                  if(currUser == snapshot.data.documents[i].documentID){
                                    if(snapshot.data.documents[i].data['phrase'] != null){
                                      return buildW();
                                    }
                                  }
                                }
                                print("LLLLLLLLLLLLLL");
                                print(ask);

                                if(snapshot.data.documents[ask].data["phrase"]!=null){
                                  var question = snapshot.data.documents[ask].data["phrase"];
                                  return buildN(question);
                                }
                                return Text("ᎠᏛᏓᏍᏗ ᎯᎦᏘᏓ...",  style: GoogleFonts.bubblegumSans(textStyle: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 15,
                                )),);
                              },
                            )
                          ],
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
void startTimer(controller) {
  controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
}
class Record {
  final String phrase;
  final int votes;
  final int score;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['phrase'] != null),
        assert(map['vote'] != null),
        assert(map['score'] != null),
        phrase = map['phrase'],
        votes = map['vote'],
        score = map['score'];
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$phrase:$votes:$score>";
}