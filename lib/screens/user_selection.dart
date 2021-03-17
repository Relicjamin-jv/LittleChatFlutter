import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/Shared/loading.dart';

import 'home.dart';

class user_selection extends StatefulWidget {
  @override
  _user_selectionState createState() => _user_selectionState();
}

class _user_selectionState extends State<user_selection> {
  List<String> wantedUser = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Start a Chat",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //TODO add a search function for the user to search for an user
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
          if(snap.hasData){
            return new ListView(
              children: snap.data.docs.map((DocumentSnapshot document){
                return new ListTile(
                  onTap: () {
                    String adding_user = (document.data()['uid']);
                    if(wantedUser.contains(adding_user)){
                      wantedUser.remove(adding_user);
                    }else{
                      wantedUser.add(adding_user);
                    }
                    setState(() {

                    });
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      '${document.data()['displayName'][0]}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: new Text(document.data()['displayName']),
                  selected: (wantedUser.contains(document.data()['uid'])),
                );
              }).toList(),
            );
          }else if(snap.hasError){
            print("We have a problem");
            return home();
          }else{
            return Loading();
          }
        }
      ),
    );
  }
}
