import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/Service/database.dart';
import 'package:little_chat/Shared/loading.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/models/userdatamodel.dart';
import 'package:provider/provider.dart';


import 'home.dart';

class user_selection extends StatefulWidget {


  @override
  _user_selectionState createState() => _user_selectionState();
}

class _user_selectionState extends State<user_selection> {
  List<String> wantedUser = [];
  List<String> memberNames = [];

  @override
  Widget build(BuildContext context) {
    final userSelectionProvidor = Provider.of<userInfo>(context);
    final userUid = userSelectionProvidor.uid;
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
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
            if (snap.hasData) {
              return new ListView(
                children: snap.data.docs.map((
                    DocumentSnapshot document) { //this was stupidly painful to get working dont really monkey with this
                  if ((document.data()['uid']) !=
                      userUid) { //need to still return a widget for all of them, or otherwise it will throw an error on null widget
                    return new ListTile(
                      onTap: () {
                        String adding_user = (document.data()['uid']);
                        String adding_userName = (document.data()['displayName']);
                        if (wantedUser.contains(adding_user)) {
                          wantedUser.remove(adding_user);
                          memberNames.remove(adding_userName);
                        } else {
                          wantedUser.add(adding_user);
                          memberNames.add(adding_userName);
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
                  } else {
                    return Container(
                    );
                  }
                }).toList(),
              );
            } else if (snap.hasError) {
              print("We have a problem");
              return home();
            } else {
              return Loading();
            }
          }
      ),
      floatingActionButton: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users")
              .doc(userUid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snap) {
            return FloatingActionButton(
              onPressed: () {
                int type;
                wantedUser.add(userUid);
                memberNames.add(snap.data['displayName']);
                if (wantedUser.length <= 2) {
                  type = 0;
                } else {
                  type = 1;
                }
                int uuidgroupint = wantedUser.toString().hashCode;
                String uuidgroup = uuidgroupint.toString();
                print(uuidgroup);
                DataBaseService().updateGroupData(
                    uuidgroup, memberNames, userUid, wantedUser,
                    type); //setting up the group data for all the users, making a new document collection
                DataBaseService().setMessageData("hVmDXtVSX2Z80zcZgoXCboNndtf2", "Welcome! Contact me if you find any bugs. -Automatic message", DateTime.now(), [], uuidgroup, 0, "");
                for (var i = 0; i < wantedUser.length; i++) {
                  DataBaseService()
                      .updateUserGroups([uuidgroup], wantedUser[i]) //add each user to the group in the users collection
                      .catchError((onError) =>
                      print(
                          "there was an error updating groups")); //this should add the new group to all the relavant users
                }

                wantedUser.clear();
                memberNames.clear();
                Navigator.pop(context);
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.arrow_forward_sharp),
            );
          }
      ),
    );
  }
}
