import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseUser user;
String name;
String email;
String imageUrl;
String currUser;
var SignedIn = false;



Future<String> signInWithGoogle() async {

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;


  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();

  assert(user.uid == currentUser.uid);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;


  try {
    FirebaseUser user = (await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email)).user;
    currUser = user.uid;
    email = email;
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
        fontSize: 16.0);


  } catch (e) {
    Fluttertoast.showToast(
        msg: "Register Failed - Please Retry",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black26,
        textColor: Colors.white,
        fontSize: 16.0);
  }



// Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }


  return 'signInWithGoogle succeeded: $user';




}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}

