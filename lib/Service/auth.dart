import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/screens/home.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String token = '';

  /*creates a firebase instance, allows to interact with Firebase Auth*/

  /*creates a User type of the Firebase user*/
  userInfo _userFromFirebaseCredential(UserCredential userCredential) {
    return userCredential != null
        ? userInfo(uid: userCredential.user.uid)
        : null;
  }

  userInfo _userFromFirebase(User user) {
    return user != null ? userInfo(uid: user.uid) : null;
  }

  // // setting up a stream connection to see if the user is still logged in or not
  // StreamSubscription<User> get user{
  //   return _auth.authStateChanges().listen((User user) {
  //     if(user == null){
  //       print("the user is logged out");
  //     }else{
  //       print("The user is logged in");
  //     }
  //   });
  // }

  Stream<userInfo> get authState =>
      _auth.authStateChanges().map((User authState) => _userFromFirebase(
          authState)); //the state of the user being logged in or not

  //signing in with email and password
  Future signInUsernamePassword(String userName, String passWord) async {
    String displayName = "";
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userName, password: passWord);
      List<String> displayName = _toDisplayName(userName);
      await getToken().whenComplete(() => {
        DataBaseService(uid: userCredential.user.uid).updateUserData(
        capitalize(displayName[0]) + " " + capitalize(displayName[1]),
        ["Everybody"], token)
      });
      return _userFromFirebaseCredential(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return null;
    }
  }

  Future getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) => {
      token = value,
      print(token)
    });
  }

  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  List<String> _toDisplayName(String userName) {
    String tmp = userName;
    List<String> string = tmp.split("@");
    return string[0].split(".");
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
