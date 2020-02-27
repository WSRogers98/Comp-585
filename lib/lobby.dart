import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test8/SizeConfig.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test8/main.dart';
import 'package:test8/vote.dart';
import 'package:test8/room.dart';
import 'package:test8/GameScreen.dart';


class lobbyPage extends StatefulWidget {
  @override
  _lobbyState createState() => _lobbyState();
}
class _lobbyState extends State<lobbyPage> {

  String player1;
  String player2;
  String _roomNum;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('lobby')),
        body:
        //////////////////////////PPPPPPPLLLLLLLZZZZZZ make the below items layout in the same page, the column I commented out and the stream builder
        Column(
            children: [

              RaisedButton(
                child: Text("Start a Room"),
                onPressed: startRoom,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              TextField(
                controller: myController,
              ),
//              TextFormField(
//                onSaved: (input) => _roomNum = input,
//              ),
              RaisedButton(
                child: Text("Join a Room"),
                onPressed: joinRoom,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(

                child: Text("Start Game"),
                onPressed: () {
                  Firestore.instance
                      .collection('gameSessions')
                      .document(_roomNum)
                      .updateData({
                    'GameOpen': false
                  });
                  completeRoom(context);
                },
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),

//              StreamBuilder(
//                stream: Firestore.instance.collection('gameSessions').snapshots(),
//                //print an integer every 2secs, 10 times
//                builder: (context, snapshot) {
//                  if (!snapshot.hasData) {
//                    player1 = snapshot.data.documents[0]['player1'];
//                    player2 = snapshot.data.documents[0]['player1'];
//                    return Text("Loading..");
//                  }
//                  return ListView.builder(
//                    itemExtent: 80.0,
//                    itemCount: 2,
//                    itemBuilder: (context, index) {
//                      return ListTile(
//
//                          title: Text(snapshot.data.documents[index]['player1']),
//                          subtitle: Text(snapshot.data.documents[index]['player2']),
//                      );
//                    }
//                  );
//                },
//              ),
            ]
        )
    );

    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
      super.dispose();
    }
  }

  void startRoom() {
    var randNum = new Random();
    print(currUser);
    _roomNum = randNum.nextInt(10000).toString();
    print(_roomNum);
    if(currUser!=null) {
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .setData({
        'roomNumber': _roomNum,
        'player1': currUser,
      });
    }
  }

  void joinRoom() async {
    _roomNum = myController.text;

    print(_roomNum);

//      List<DocumentSnapshot> templist;
//
//      var players = Firestore.instance.collection('gameSessions').getDocuments().toString();

    //List<String> players = (List<String>) Firestore.instance.collection('gameSessions').
    //List<String> group = (List<String>) document.get("dungeon_group");
    //var testing =  players.docs.map(doc => doc.data());

//      var list = templist.map((DocumentSnapshot players){
//        return players.data;
//      }).toList();


    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = new List();
    CollectionReference collectionRef = Firestore.instance.collection(
        "gameSessions");
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents;

    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();

    var room;

    for (var i = 0; i < list.length; i++) {
      print(_roomNum);
      if (list[i]["roomNumber"] == _roomNum) {
        room = list[i];
      }
    }

    int numPlayers = 1;
    for (var key in room.keys) {
      if (key.startsWith("player")) numPlayers++;
    }

    var playerNumString = "player" + numPlayers.toString();

    if(currUser!=null) {
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .updateData({
        playerNumString: currUser
      });
    }
  }


  Future completeRoom(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyGame()));
  }


}