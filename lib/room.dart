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
import 'package:test8/lobby.dart';

void mainRoom() => runApp(thisRoom());

class thisRoom extends StatelessWidget {
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
      home: new LobbyRoom(),
    );
  }
}

class LobbyRoom extends StatefulWidget{
  @override
  _MyHomePageState createState() => new _MyHomePageState();

}

class _MyHomePageState extends State<LobbyRoom> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('gameSessions').document(
            _roomNum).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return new Text(userDocument["player1"]);
        }
    );
  }
}