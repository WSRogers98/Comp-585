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

String player1;
String player2;
String _roomNum;
final myController = TextEditingController();
class lobbyPage extends StatefulWidget {
  @override
  _lobbyState createState() => _lobbyState();
}
class _lobbyState extends State<lobbyPage> {

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
              TextFormField(
                onSaved: (input) => _roomNum = input,
              ),
              RaisedButton(
                child: Text("Join a Room"),
                onPressed: joinRoom,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(

                child: Text("Start a Game"),
                onPressed: () {
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
  }
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}

void startRoom(){
  var randNum = new Random();
  _roomNum = randNum.nextInt(10000).toString();
  print(_roomNum);
  Firestore.instance
      .collection('gameSessions')
      .document(_roomNum)
      .setData({
    'player1': currUser,
    'player2' : ''
  });
}

void joinRoom(){
  print(_roomNum);
  _roomNum = myController.text;
  Firestore.instance
      .collection('gameSessions')
      .document(_roomNum)
      .setData({
    'player2': currUser
  });
}


Future completeRoom(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => roomPage()));
}
void completeRoooom(){

//  StreamBuilder<QuerySnapshot>(
//    stream: Firestore.instance.collection('users').snapshots(),
//    builder: (context, snapshot) {
//      if (!snapshot.hasData) return LinearProgressIndicator();
//      //return snapshot.data.documents;
//    },
//  );
//
//  Firestore.instance
//      .collection("gameSessions")
//      .getDocuments()
//      .then((QuerySnapshot snapshot) {
//      print(snapshot.documents[0].data);
////    snapshot.documents.forEach((f) => print('${f.data}}'));
//  });
//  //final record = Record.fromSnapshot(data);
//  //print(record.name);
}

