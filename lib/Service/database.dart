import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:little_chat/models/message_model.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/models/userdatamodel.dart';

class DataBaseService {

  final String uid;

  DataBaseService({this.uid});

  // collection reference
  bool userAlreadyExist = false;
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance
      .collection("group");
  final CollectionReference messageCollection = FirebaseFirestore.instance
      .collection("message");

  Future updateUserData(String displayName, List<String> groups) async {
    await _collectionExist();
    if (userAlreadyExist == false) {
      return await userCollection.doc(uid).set({
        'uid': uid,
        'displayName': displayName,
        'groups': groups,
      })
          .then((value) => print("user added to the documents")
      ).catchError((onError) => print("Failed to add user: $onError"));
    } else {
      print("The user already exist in the collection");
    }
  }

  Future updateGroupData(String guid, String displayName, String createdBy,
      List<String> membersUid) async {
    return await groupCollection.doc(guid).set({
      'displayName': displayName,
      'createdBy': createdBy,
      'membersUid': membersUid,
    });
  }

  //couldnt get it to work but it heres so if I deciede if I want to figure it out later I will
  Future getAllUsers() async {
    return await userCollection.get().then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs
    });
  }

  //leaving here until there is a need fo r it
  Future updateMessageData(String sentBy, String text, String time,
      List<String> read, String groupID) async {
    return await messageCollection.doc(groupID).set({
      'sentBy': sentBy,
      'text': text,
      'read': [" "],
      'groupID': groupID,
    });
  }

  Future<bool> _collectionExist() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists == false) {
        userAlreadyExist = false;
        return Future<bool>.value(false);
      } else {
        userAlreadyExist = true;
        return Future<bool>.value(true);
      }
    });
  }

  user_data _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return user_data(
      displayName: snapshot.data()['displayName'],
      groups: snapshot.data()['groups'],
    );
  }

  Stream<DocumentSnapshot> get userData {
    return userCollection.doc(uid).snapshots();
  }

}








    

