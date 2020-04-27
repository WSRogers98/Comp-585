import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:Cherokee/main.dart';
import 'package:Cherokee/room.dart';
import 'package:Cherokee/GameScreenQ.dart';
import 'package:Cherokee/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

String joinRoomNum;

class lobbyPage extends StatefulWidget {
  @override
  _lobbyState createState() => _lobbyState();
}

class _lobbyState extends State<lobbyPage> {
  int roomDocIndex;
  String player1;
  String player2;
  String _roomNum;
  final myController = TextEditingController();
  int roomListLength;
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
    const themeColor = const Color(0xffb77b);

    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text("lobby"),

          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  _audioCache.play('button.mp3');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Column(

            children: [
              Container(margin: const EdgeInsets.only(top: 20.0),
          child:
          RaisedButton(
            child: Text("Start a Room",style: TextStyle(fontSize: 20)),

            onPressed: () {
              _audioCache.play('button.mp3');
              startRoom();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => lobbyOPage()));
            },
            color: Colors.orangeAccent.withOpacity(0.9),

            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.orangeAccent),
            ),
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
            splashColor: Colors.grey,
          ),),
          TextField(
            controller: myController,
          ),
          Container(margin: const EdgeInsets.only(top: 20.0),
          child:
          RaisedButton(

            child: Text("Join a Room",style: TextStyle(fontSize: 20)),
            onPressed: () {
              _audioCache.play('button.mp3');
              joinRoom();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => lobbyJPage()));
            },
            color: Colors.orangeAccent.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.orangeAccent),
            ),
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
            splashColor: Colors.grey,
          ),),

          Flexible(
            child: _buildBody(context),
          ),
          //roomList(context)
        ]));
//    }
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('gameSessions').snapshots(),
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
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.name),
            trailing: Text("0"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyRoom()));
              joinRoomNum = record.name;
            }),
      ),
    );
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  int roomListNumber() {
    int z;
    //x.then((var y)=>z = y.documents.length);
    return z;
    //print(z);
  }

  void startRoom() {
    var randNum = new Random();
    //print(currUser);
    _roomNum = randNum.nextInt(10000).toString();

    //print(_roomNum);
    if (currUser != null) {
      Firestore.instance.collection('gameSessions').document(_roomNum).setData({
        'GameOpen': false,
        'roomNumber': _roomNum,
        "ask": 0,
      });
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .collection('players')
          .document(currUser)
          .setData({
        'vote': 0,
        'score': 0,
        'phrase': null,
        'nextRound': true,
        'email': email,
      });
      Firestore.instance
          .collection('users')
          .document(currUser)
          .updateData({'room': _roomNum, 'owner': true});
    }
  }

  void joinRoom() async {
    _roomNum = myController.text;


    if (currUser != null) {
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .collection('players')
          .document(currUser)
          .setData({
        'phrase': null,
        'vote': 0,
        'score': 0,
        'nextRound': true,
        'email': email,
      });
      Firestore.instance
          .collection('users')
          .document(currUser)
          .updateData({'room': _roomNum, 'owner': false});
    }
  }

  // this function grabs and returns a list of players in a specified gameSession
  Future<List<String>> getPlayers() async {
//      var grabtest = Firestore.instance.collection('gameSessions').document(_roomNum).collection('players').getDocuments();
//
//      _roomNum = 7382.toString();

    List<DocumentSnapshot> templist;
    List<String> list = new List();
    CollectionReference collectionRef = Firestore.instance
        .collection('gameSessions')
        .document(_roomNum)
        .collection('players');
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data['email'];;
    }).toList();

    return list;
  }

  Future completeRoom(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyGame()));
  }

  Future<QuerySnapshot> getDocuments() async {
    return await Firestore.instance
        .collection('gameSessions')
        .document(_roomNum)
        .collection('players')
        .getDocuments();
  }
}

class Record {
  final String name;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['roomNumber'] != null),
        name = map['roomNumber'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
