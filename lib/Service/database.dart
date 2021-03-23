import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:little_chat/models/message_model.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/models/userdatamodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  final CollectionReference scheduleCollection = FirebaseFirestore.instance.
      collection("schedule");

  Future updateUserData(String displayName, List<String> groups) async {
    await _collectionExist();
    if (userAlreadyExist == false) {
      return await userCollection.doc(uid).set({
        'uid': uid,
        'displayName': displayName,
        'groups' : groups,
      })
          .then((value) => print("user added to the documents")
      ).catchError((onError) => print("Failed to add user: $onError"));
    } else {
      print("The user already exist in the collection");
    }
  }

  Future updateScheduleData(String photoUrl, String doc, DateTime time) async {
    return await scheduleCollection.doc(doc).set({
      'photoUrl': photoUrl,
      'date' : time
    }).then((value) => print("shed info added to the documents")).catchError((onError) => print("failed shed upload"));
  }

  Future updateGroupData(String guid, List<String> displayName, String createdBy,
      List<String> membersUid, int type) async {
    return await groupCollection.doc(guid).set({
      'displayName': displayName,
      'createdBy': createdBy,
      'membersUid': membersUid,
      'type' : type,
      'guid' : guid,
    }).then((value) => print("group info added to the documents")).catchError((onError) => print("failed group upload"));
  }

  Future updateUserGroups(List<String> guid, String uid) async {
    return await userCollection.doc(uid).update({
      'groups' : FieldValue.arrayUnion(guid),
    });
  }

  //couldnt get it to work but it heres so if I deciede if I want to figure it out later I will
  Future getAllUsers() async {
    return await userCollection.get().then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs
    });
  }

  Future getAllGroups() async
  {
    List groups = [];
    return await groupCollection.get().then((QuerySnapshot document) => {
      document.docs.forEach((element) {

      })
    });
  }
  //leaving here until there is a need fo r it
  Future setMessageData(String sentBy, String text, String time,
      List<String> read, String groupID) async {
    return await messageCollection.doc(groupID).set({
      'sentBy': sentBy,
      'text': text,
      'read': [" "],
      'groupID': groupID,
    });
  }

  Future getScheduleURL() async{
    List items = [];
    try {
      await scheduleCollection.orderBy('date', descending: true).get().then((QuerySnapshot querySnapshot) =>
      {
        querySnapshot.docs.forEach((element) {
          items.add(element.data());
        })
      });
      return items;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  Future getDisplayNames() async {
    List items = [];
    try{
      await FirebaseFirestore.instance.collection('group').get().then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((element) {
          items.add(element.data());
        })
      });
      return items;
    }catch(e){
      print(e.toString());
    }
  }
  
  Future getDisplayGroup(String groupuid) async{
    dynamic displayName;
    try {
      await groupCollection.doc(groupuid).get().then((
          DocumentSnapshot documentSnapshot) =>
      {
        displayName = documentSnapshot.data(),
      });
    }catch (e){
      print(e.toString());
    }
    return displayName;

  }

  Future getDisplayName(String uuid) async{
    dynamic displayName;
    print(uuid);
    try {
      await groupCollection.doc(uuid).get().then((
          DocumentSnapshot documentSnapshot) =>
      {
        displayName = documentSnapshot.data(),
      });
    }catch (e){
      print(e.toString());
    }
    return displayName;

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




  // Stream<DocumentSnapshot> get groupData{
  //   return groupCollection.doc(guid).snapshots();
  // }
}








    

