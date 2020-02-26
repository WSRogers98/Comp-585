import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyGame());

class MyGame extends StatelessWidget {
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
      home: new GamePage(),
    );
  }
}

class GamePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => new _MyHomePageState();

}
class _MyHomePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    const thiscolor = const Color(0x6BA7B5);
    const backgroundColor = const Color(0xffb77b);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Game goes here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}