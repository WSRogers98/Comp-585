import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:Cherokee/main.dart';
import 'package:Cherokee/roomJ.dart';
import 'package:Cherokee/GameScreenQ.dart';
import 'package:Cherokee/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:Cherokee/GameScreenA0.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

String joinedRoom;
bool ownerForEnd = true;

class lobbyOPage extends StatefulWidget {
  @override
  _lobbyOState createState() => _lobbyOState();
}

class _lobbyOState extends State<lobbyOPage> {
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
    checkIfOpen();
  }

  void checkIfOpen() {
    //this code is to periodically check if GameOpen has been set to true by the room owner, if it is true
    //then move them to gamescreen
    Timer.periodic(Duration(seconds: 2), (timer) async {

      var sessionQuery = Firestore.instance
          .collection('gameSessions')
          .where('roomNumber', isEqualTo: joinedRoom)
          .limit(1);
      var querySnapshot = await sessionQuery.getDocuments();
      var documents = querySnapshot.documents;
      if (documents.length == 0) {
        /*room doesn't exist? */ return;
      }
      var isGameOpen = documents[0].data['GameOpen'];
      var docs =
      await documents[0].reference.collection("players").getDocuments();
      var askUser = docs.documents[documents[0].data['ask']].documentID;

      if (isGameOpen == true) {
        if (askUser == currUser) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyGame()));
          timer.cancel();
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AnswerTimer()));
          timer.cancel();
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
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
        body: Column(children: [
          Container(margin: const EdgeInsets.only(top: 20.0),
              child:Text('room number:',style: TextStyle(fontSize: 15)),),

          Flexible(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(currUser)
                  .snapshots(),
              builder: (context, snapshot) {
                joinedRoom = snapshot.data['room'];

                if (!snapshot.hasData) return LinearProgressIndicator();
                return Text(snapshot.data['room'],style: TextStyle(fontSize: 35));
              },
            ),
          ),
          Container(margin: const EdgeInsets.only(top: 15.0),
            child:Text('room member:',style: TextStyle(fontSize: 15)),),

          Flexible(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(currUser)
                  .snapshots(),
              builder: (context, snapshot) {
                joinedRoom = snapshot.data['room'];

                if (!snapshot.hasData) return LinearProgressIndicator();
                return _buildMem(context, joinedRoom);
              },
            ),
          ),
          Container(margin: const EdgeInsets.only(top: 10.0),
            child:
          RaisedButton(
            child: Text("Start Game",style: TextStyle(fontSize: 20)),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.orangeAccent),
            ),
            onPressed: () {
              _audioCache.play('button.mp3');
              Firestore.instance
                  .collection('gameSessions')
                  .document(joinedRoom)
                  .updateData({'GameOpen': true});
              completeRoom(context);
            },
            color: Colors.orangeAccent,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(41, 10, 41, 10),
            splashColor: Colors.grey,
          ),),
          Container(margin: const EdgeInsets.only(top: 10.0),
            child:
          RaisedButton(
            child: Text("Delete Room",style: TextStyle(fontSize: 20)),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.orangeAccent),
            ),
            onPressed: () {
              _audioCache.play('button.mp3');
              Firestore.instance
                  .collection('gameSessions')
                  .document(joinedRoom)
                  .delete();
              Firestore.instance
                  .collection('users')
                  .document(currUser)
                  .updateData({'room': null, 'owner': false});
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => lobbyPage()));
            },
            color: Colors.orangeAccent,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
            splashColor: Colors.grey,
          ),),
          Flexible(
            child: _buildBody(context),
          ),
          //roomList(context)
        ]));
  }

  Widget _buildMem(BuildContext context, String joinedRoom) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('gameSessions')
            .document(joinedRoom)
            .collection('players')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildCol(
              context,
              snapshot.data.documents.map((DocumentSnapshot docSnapshot) {
                return docSnapshot.data['email'];
              }).toList());
        });
  }

  Widget _buildCol(BuildContext context, List snapshot) {
    return Column(
      children: <Widget>[for (var item in snapshot) Text(item,style: TextStyle(fontSize: 20))],
    );
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
                  context, MaterialPageRoute(builder: (context) => MyRoomJ()));
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
      return docSnapshot.documentID;
    }).toList();

    return list;
  }

  Future completeRoom(context) async {
    var sessionQuery = Firestore.instance
        .collection('gameSessions')
        .where('roomNumber', isEqualTo: joinedRoom)
        .limit(1);
    var querySnapshot = await sessionQuery.getDocuments();
    var documents = querySnapshot.documents;
    if (documents.length == 0) {
      /*room doesn't exist? */ return;
    }
    var docs =
    await documents[0].reference.collection("players").getDocuments();
    var firstUser = docs.documents[0].documentID;
    if (firstUser == currUser) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyGame()));
      timer.cancel();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AnswerTimer()));
      timer.cancel();
    }
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

var timer = Timer(
    Duration(seconds: 2),
        () => print(
        '----------------------- 2 seconds have passed ----------------------'));