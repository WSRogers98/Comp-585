import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test8/SizeConfig.dart';
import 'package:test8/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
            child: RaisedButton(
              onPressed: () {
                // comment this out to run app
                signInWithGoogle();
              },
              child: const Text('Profile', style: TextStyle(fontSize: 10)),
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
