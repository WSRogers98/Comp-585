import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Cherokee/main.dart';
import 'dart:math';
import 'package:Cherokee/SizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Cherokee/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:Cherokee/LessonOne.dart';
import 'package:Cherokee/LessonTwo.dart';
import 'package:Cherokee/LessonThree.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimationRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = const Color(0xffb77b);
    const buttoncolor = const Color(0x6BA7B5);
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
  _MyLearnPageState createState() => new _MyLearnPageState();
}

class _MyLearnPageState extends State<GamePage> {
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
    const backgroundColor = const Color(0xffb77b);
    const buttoncolor = const Color(0x6BA7B5);
    var randomizer = new Random();
    var num = randomizer.nextInt(10);
    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(1),
      body: Container(
        decoration: BoxDecoration(
          // decoration box for background Image
          image:  DecorationImage(
            image: AssetImage('assets/animations/$num.gif'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
