import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseService {

  final String uid;

  DataBaseService({this.uid});

  // collection reference
  bool userAlreadyExist = false;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("group");
  final CollectionReference messageCollection = FirebaseFirestore.instance.collection("message");

  Future updateUserData(String displayName, List<String> groups) async {
    await _collectionExist();
    if (userAlreadyExist == false) {
      return await userCollection.doc(uid).set({
        'displayName': displayName,
        'groups': groups,
      })
          .then((value) => print("user added to the documents")
      ).catchError((onError) => print("Failed to add user: $onError"));
    }else{
      print("The user already exist in the collection");
    }
  }
  Future updateGroupData(String guid, String displayName, String createdBy, List<String> membersUid ) async {
    return await groupCollection.doc(guid).set({
      'displayName': displayName,
      'createdBy': createdBy,
      'membersUid': membersUid,
    });
  }
  Future updateMessageData(String sentBy, String text, String time, List<String> read, String group) async {
    return await messageCollection.doc(group).set({
      'sentBy': sentBy,
      'text': text,
      'read': [" "],
      'group': group,
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
      }else{
        userAlreadyExist = true;
        return Future<bool>.value(true);
      }
    });

  }
    

}