import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test8/SizeConfig.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/lobby.dart';

String _email, _password;
String currUser;
var user = FirebaseUser;
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

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => new _MyHomePageState();

}
class _MyHomePageState extends State<MyHomePage> {
  @override
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context){
    SizeConfig().init(context);
    const thiscolor= const Color(0x6BA7B5);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image:  const DecorationImage(
              image: AssetImage('assets/images/tempBackground.png'),
              fit: BoxFit.fill,
            ),
          ),
          child:SafeArea(
            child: Stack(
              children: <Widget>[
            Container(
            child: Align(
                alignment: Alignment(.40,.70),
            child: RaisedButton(
              onPressed: () async {
                print('clicked');
              },
              child: Text('Learn', style: TextStyle(fontSize: 10)),
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
          alignment: Alignment(-.40,.70),
          child: RaisedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => lobbyPage()));
              print('clicked');
            },
            child: Text('Play', style: TextStyle(fontSize: 10)),
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
                   alignment: Alignment(0,.9),

                    child:
                    user == null ? RaisedButton(
                    onPressed: () async {
                     print('clicked');
                      },
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
        print('clicked');
                showDialog(
                  context: context,
                  builder: (BuildContext context){
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
                          onSaved: (input) => _email = input,),
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
                            onSaved: (input) => _password = input),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: signIn,
                        ),
                      )
                          ],
                        ),
                      ),
                    );
                  }
                );
        },
          child: Text('Sign In', style: TextStyle(fontSize: 10)),
          color: thiscolor.withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),

          ),
          textColor: Colors.white,
          elevation: 15,
        ),
          ),
                ),
              ]
            ),
          ),
    ),
    );
  }
  void signIn() async {
    print("signin");
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        currUser = user.uid;
        print(user);
//        Navigator.push(context, MaterialPageRoute(builder: (context) => lobbyPage()));
      }catch(e){
        print("notFound");
        print(e.message);
      }
    }
  }
}


















