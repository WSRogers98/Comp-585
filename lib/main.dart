import 'package:flutter/material.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cherokee Learning Game',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: AppBar(title: Text('Splash Screen')),
        body: LayoutBuilder(
          builder: (context, constraints) =>
              Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Material(color: Colors.white),
                  Positioned(
                    top: 290,
                    left:50,
                    height: 30,
                    width:70,
                    child:  RaisedButton(
                      onPressed: () {},
                      child: Text('Play'),
                    ),
                  ),
                  Positioned(
                    top: 290,
                    left: 150,
                    height: 30,
                    width:70,
                    child:  RaisedButton(
                      onPressed: () {},
                      child: Text('Learn'),
                    ),
                  ),
                  Positioned(
                    top: 330,
                    left: 90,
                    height: 30,
                    width:84,
                    child:  RaisedButton(
                      onPressed: () {},
                      child: Text('Profile'),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right:5,
                    height: 25,
                    width:25,
                    child:  FloatingActionButton(
                      child: Icon(Icons.settings),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}