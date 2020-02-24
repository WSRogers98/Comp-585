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
String _roomNum;
class lobbyPage extends StatefulWidget {
  @override
  _lobbyState createState() => _lobbyState();
}
class _lobbyState extends State<lobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('lobby')),
        body: Column(
            children: [
              RaisedButton(
                child: Text("Start a Room"),
                onPressed: startRoom,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
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
                onPressed: completeRoom,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),

            ]
        )
    );
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
    'player1': currUser
  });
}

void joinRoom(){
  print(_roomNum);
  Firestore.instance
      .collection('gameSessions')
      .document(_roomNum)
      .updateData({
    'player2': currUser
  });
}

void completeRoom(){
//  Firestore.instance
//      .collection("gameSessions")
//      .getDocuments()
//      .then((QuerySnapshot snapshot) {
//  snapshot.documents.forEach((f) => print('${f.data}}'));
//  });

  Firestore.instance
      .collection("gameSessions")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
      print(snapshot.);
//    snapshot.documents.forEach((f) => print('${f.data}}'));
  });
}

