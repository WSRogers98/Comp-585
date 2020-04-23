
import 'package:flutter/material.dart';

import 'LoginPage.dart';

void main() => runApp(SignInWithGoogler());

class SignInWithGoogler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}