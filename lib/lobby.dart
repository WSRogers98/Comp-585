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

int currDocLength = 0;
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

  Widget _buildList(BuildContext context, String playerID) {
    print("ooo");
    return ListTile(

      title: Text(playerID),
      //subtitle: Text(document['bod']),
    );
  }

  Widget _buildLoopDoc(BuildContext context, DocumentSnapshot document,
      int docLength) {
    return ListView.builder(
      itemExtent: 80.0,
      itemCount: docLength,
      itemBuilder: (context, index) {
        print("ppp");

        return _buildList(context, document[docLength.toString()]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('lobby')),
        body:
        Column(
            children: [
              RaisedButton(
                child: Text("Start a Room"),
                onPressed: startRoom,
                color: Colors.orangeAccent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                splashColor: Colors.grey,
              ),
              TextField(
                controller: myController,
              ),
              RaisedButton(
                child: Text("Join a Room"),
                onPressed: joinRoom,
                color: Colors.orangeAccent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                color: Colors.orangeAccent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                splashColor: Colors.grey,
              ),
//              Flexible(
//                child:
//                StreamBuilder(
//                  stream: Firestore.instance.collection('gameSessions')
//                      .snapshots(),
//                  //print an integer every 2secs, 10 times
//                  builder: (context, snapshot) {
//                    if (!snapshot.hasData) {
//                      return Text("Loading..");
//                    }
//                    return ListView.builder(
//                      itemExtent: 80.0,
//                      itemCount: 1,
//                      itemBuilder: (context, index) {
////                        for (int i = 0; i <
////                            snapshot.data.documents.length; i++) {
////                          print(snapshot.data.documents[i]['roomNumber']);
////                          if (_roomNum ==
////                              snapshot.data.documents[i]['roomNumber']) {
////                            roomDocIndex = i;
////                          }
////                        }
////                        print('rm' + roomDocIndex.toString());
////                        print(snapshot.data.documents[roomDocIndex].reference);
//                        return _buildLoopDoc(
//                            context, snapshot.data.documents[roomDocIndex],
//                            snapshot.data.documents[roomDocIndex]
//                                .data()
//                                .length);
//                      },
//                    );
//                  },
//                ),
//              )


            ])
    );
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void startRoom() {
    var randNum = new Random();
    print(currUser);
    _roomNum = randNum.nextInt(10000).toString();

    print(_roomNum);
    if (currUser != null) {
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .setData({
        'roomNumber': _roomNum,
      });
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .collection('players').document(currUser)
          .setData({
        'question': '',
        'answer': '',
      });
    }
  }

  void joinRoom() async {
    _roomNum = myController.text;

    //print(_roomNum);

//      List<DocumentSnapshot> templist;
//
//      var players = Firestore.instance.collection('gameSessions').getDocuments().toString();

    //List<String> players = (List<String>) Firestore.instance.collection('gameSessions').
    //List<String> group = (List<String>) document.get("dungeon_group");
    //var testing =  players.docs.map(doc => doc.data());

//      var list = templist.map((DocumentSnapshot players){
//        return players.data;
//      }).toList();


//    List<DocumentSnapshot> templist;
//    List<Map<dynamic, dynamic>> list = new List();
//    CollectionReference collectionRef = Firestore.instance.collection(
//        "gameSessions");
//    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();
//
//    templist = collectionSnapshot.documents;
//
//    list = templist.map((DocumentSnapshot docSnapshot) {
//      return docSnapshot.data;
//    }).toList();
//
//    var room;
//
//    for (var i = 0; i < list.length; i++) {
//      print(_roomNum);
//      if (list[i]["roomNumber"] == _roomNum) {
//        room = list[i];
//      }
//    }
//
//    int numPlayers = 1;
//    for (var key in room.keys) {
//      if (key.startsWith("player")) numPlayers++;
//    }
///////////////////////////////////////////
    //   var playerNumString = "player" + numPlayers.toString();

    if (currUser != null) {
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .collection('players').document(currUser)
          .setData({
        'question': '',
        'answer': '',
      });
      print(_roomNum + "ii");
    }
  }


  Future completeRoom(context) async {
    print(getDocuments().then((value)=>(value.documents.length)));
    print('h');
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
