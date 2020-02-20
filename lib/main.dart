import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test8/SizeConfig.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);
  return user;
}
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
          minWidth: 30
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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image:  const DecorationImage(
              image: AssetImage('assets/images/tempBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment(0,.97),

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
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                            }
                          },
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
          )
          ),
    ),
    );
  }
}
