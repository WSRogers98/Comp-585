import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Cherokee/SizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Cherokee/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Cherokee/lobbyO.dart';
import 'package:Cherokee/lobbyJ.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

String _email, _password, _emailReg, _passwordReg;
String currUser;
String email;
var SignedIn = false;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioCache _audioCache;
  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  @override
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const thiscolor = const Color(0x6BA7B5);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // decoration box for background Image
          image: const DecorationImage(
            image: AssetImage('assets/images/tempbackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment(.40, .70),
                child: RaisedButton(
                  onPressed: () async {
                    _audioCache.play('button.mp3');

                  },
                  // Learn Button
                  child: Text('ᎭᏕᎶᏆ', style: TextStyle(fontSize: 10)),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  textColor: Colors.white,
                  elevation: 15,
                  color: thiscolor.withOpacity(1),
                ),
              ),
            ),
            // Play Button
            Container(
              child: Align(
                alignment: Alignment(-.40, .70),
                child: RaisedButton(
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

                  },
                  // Play Button
                  child: Text('ᎭᏁᏟᏓ', style: TextStyle(fontSize: 10)),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  textColor: Colors.white,
                  elevation: 15,
                  color: thiscolor.withOpacity(1),
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment(0.4, .9),
                child: SignedIn == false
                    // conditional Switch Button Between Sign in and profile, dependent on if user is already signed in
                    ? RaisedButton(
                        onPressed: () async {
                          _audioCache.play('button.mp3');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter Email Here',
                                            ),
                                            autofocus: true,
                                            obscureText: false,
                                            onSaved: (input) => _email = input,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter Password Here',
                                              ),
                                              autofocus: false,
                                              obscureText: true,
                                              onSaved: (input) =>
                                                  _password = input),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            child: Text("Submit"),
                                            onPressed: () async{

                                              signIn();
                                              _audioCache.play('button.mp3');
                                              },

                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        // sign in section of button
                        child: Text('Sign In', style: TextStyle(fontSize: 10)),
                        color: thiscolor.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        textColor: Colors.white,
                        elevation: 15,
                      )
                    : RaisedButton(
                        onPressed: () async {
                          _audioCache.play('button.mp3');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter Email Here',
                                            ),
                                            autofocus: true,
                                            obscureText: false,
                                            onSaved: (input) => _email = input,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter Password Here',
                                              ),
                                              autofocus: false,
                                              obscureText: true,
                                              onSaved: (input) =>
                                                  _password = input),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            child: Text("Submit"),
                                            onPressed: () async{
                                              _audioCache.play('button.mp3');
                                              signIn();
                                              },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        // profile section of button
                        child: Text('Profile', style: TextStyle(fontSize: 10)),
                        color: thiscolor.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        textColor: Colors.white,
                        elevation: 15,
                      ),
              ),
            ),
            // Button to Register New User
            Container(
              child: Align(
                alignment: Alignment(-.4, 0.9),
                // Switch register Button
                child: RaisedButton(
                  onPressed: () async {
                    _audioCache.play('button.mp3');

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter Email Here',
                                      ),
                                      autofocus: true,
                                      obscureText: false,
                                      onSaved: (input) => _emailReg = input,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Enter Password Here',
                                        ),
                                        autofocus: false,
                                        obscureText: true,
                                        onSaved: (input) =>
                                            _passwordReg = input),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text("Submit"),
                                      onPressed: ()async{
                                        _audioCache.play('button.mp3');
                                        register();
                                        },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Text('Register', style: TextStyle(fontSize: 10)),
                  color: thiscolor.withOpacity(1),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  textColor: Colors.white,
                  elevation: 15,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void navToLobby() async {
    Firestore.instance.collection('users').document(currUser).get();
    StreamBuilder<DocumentSnapshot>(
      stream:
          Firestore.instance.collection('users').document(currUser).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data['room'] == null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => lobbyPage()));
        } else {
          if (snapshot.data['owner'] == false) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => lobbyJPage()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => lobbyOPage()));
          }
        }
        return null;
      },
    );
  }

  // sign in a new account
  void signIn() async {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        currUser = user.uid;

        email = _email;

        SignedIn = true;

        Fluttertoast.showToast(
            msg: "Sign In Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Sign In Failed - Please Retry",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }

  // register a new account
  void register() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _emailReg, password: _passwordReg))
            .user;
        currUser = user.uid;
        Firestore.instance
            .collection('users')
            .document(currUser)
            .setData({'room': null, 'owner': false});
        SignedIn = true;
        Fluttertoast.showToast(
            msg: "Registration Successful, you are now signed in",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Register Failed - Please Retry",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }
}
