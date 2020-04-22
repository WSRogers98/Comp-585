import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:Cherokee/main.dart';
import 'package:Cherokee/lobby.dart';
import 'package:Cherokee/GameScreenQ.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyRoomJ());

class MyRoomJ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cherokee Learning Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          height: 25,
          minWidth: 65,
        ),
      ),
      home: new roomJPage(),
    );
  }
}

class roomJPage extends StatefulWidget {
  @override
  _roomJState createState() => _roomJState();
}

class _roomJState extends State<roomJPage> {
  AudioCache _audioCache;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(
        prefix: "audio/",
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(joinRoomNum),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  _audioCache.play('button.mp3');
//              Navigator.push(context, MaterialPageRoute(builder: (context) => lobbyPage()));
                  var docSnap = await Firestore.instance
                      .collection('users')
                      .document(currUser)
                      .get();
                  var room = docSnap.data["room"];
                  var owner = docSnap.data["owner"];
                  if (room == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => lobbyPage()));
                  } else {
                    if (owner == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => lobbyOPage()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => lobbyJPage()));
                    }
                  }
                  ;
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Column(children: [
          Flexible(
              child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('gameSessions')
                .document(joinRoomNum)
                .collection('players')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(
                  context,
                  snapshot.data.documents.map((DocumentSnapshot docSnapshot) {
                    return docSnapshot.documentID;
                  }).toList());
            },
          )),
        ]));
  }

  Widget _buildList(BuildContext context, List snapshot) {
    return Column(
      children: <Widget>[for (var item in snapshot) Text(item)],
    );
  }

  void joinRoom() async {
    if (currUser != null) {
      Firestore.instance
          .collection('gameSessions')
          .document(joinRoomNum)
          .collection('players')
          .document(currUser)
          .setData({
        'phrase': null,
        'vote': 0,
        'score': 0,
        "nextRound": true
      });
      Firestore.instance
          .collection('users')
          .document(currUser)
          .updateData({'room': joinRoomNum, 'owner': false});
    }
  }
}
