

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/Service/auth.dart';
import 'package:little_chat/Service/database.dart';
import 'package:little_chat/Shared/loading.dart';
import 'package:little_chat/Shared/smallLoading.dart';
import 'package:little_chat/models/message_model.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/models/userdatamodel.dart';
import 'package:little_chat/screens/ChatScreen.dart';
import 'package:little_chat/screens/shed.dart';
import 'package:little_chat/screens/user_selection.dart';
import 'package:provider/provider.dart';
import 'package:little_chat/screens/Info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class home extends StatefulWidget {
  final String user;

  home({this.user});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<String> displayName = [];
  String displayToChat = '';

  @override
  void initState() {
    super.initState();
    requestPermissionForIos();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userInfo>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.red,
              child: DrawerHeader(
                child: Image(
                  image: AssetImage(
                    "Assets/Images/Logo.png",
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today_sharp,
              ),
              title: Text("Schedule"),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => shed())),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Start a Conversation"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => user_selection())),
            ),
            ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text("Information"),
              onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (_) => info())),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_sharp),
              title: Text("Sign out"),
              onTap: () => AuthService().signOut(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Chats",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: <Widget>[
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: DataBaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            DocumentSnapshot user = snapshot.data;
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: user.data()['groups'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () => {
                                displayToChat = displayName[index],
                                DataBaseService().updateReadMessage(user.data()['displayName'], user.data()['groups'][index]),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            chatScreen(group: displayToChat, guid: user.data()['groups'][index], user: widget.user, displayName: user.data()['displayName'])))
                                },
                              title: FutureBuilder(
                                future: _title(user.data()['groups'][index]),
                                builder: (context, snap){
                                  if(snap.hasData){
                                    bool group = true;
                                    if(snap.data['type'] == 1){
                                      group = false;
                                    }else{
                                      group = true;
                                    }
                                    String finalDisplayName = group ? snap.data['displayName'].toString().replaceAll('[', "").replaceAll(']', "").replaceAll(user.data()['displayName'], "").replaceAll(",", "")
                                        : snap.data['displayName'].toString().replaceAll('[', "").replaceAll(']', "").replaceAll(user.data()['displayName'], "You");
                                     if(finalDisplayName[0] == " " || finalDisplayName[0] == ","){
                                       finalDisplayName = finalDisplayName.substring(1);
                                     }
                                    if(!displayName.contains(finalDisplayName)) {
                                      displayName.add(finalDisplayName);
                                    }
                                    return Text(finalDisplayName);
                                  }else if(snap.hasError){
                                    return Text("There was an error");
                                  }else{
                                    return smallLoading();
                                  }
                                },
                              ),
                              leading: FutureBuilder(
                                future: _title(user.data()['groups'][index]),
                                builder: (context, snap){
                                  if(snap.hasData){
                                    String finalCircleName = snap.data['displayName'].toString().replaceAll('[', "").replaceAll(']', "").replaceAll(user.data()['displayName'], "").replaceAll(",", "");
                                    if(finalCircleName[0] == " "){
                                      finalCircleName = finalCircleName.substring(1);
                                    }
                                    return CircleAvatar(
                                        backgroundColor: Colors.red,
                                      child: Text(
                                          finalCircleName[0],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                      ),
                                    );
                                  }else if(snap.hasError){
                                    return Text("There was an error");
                                  }else{
                                    return smallLoading();
                                  }
                                },
                              ),
                              subtitle: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("messages").where("groupUid", isEqualTo: user.data()['groups'][index]).orderBy('time', descending: true).limit(1).snapshots(),
                                builder: (context, snapshot) {
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data.docs[0].data()['sentBy']).snapshots(),
                                    builder: (context, displaySnap) {
                                      if(displaySnap.hasData && snapshot.hasData) {
                                        return snapshot.data.docs[0].data()['type'] == 0 ? Text(
                                          displaySnap.data
                                              .data()['displayName'] + ": " +
                                              snapshot.data.docs[0].data()['text'],
                                          overflow: TextOverflow.ellipsis,
                                        ) : Text(
                                            displaySnap.data
                                                .data()['displayName'] + ": " + "Image...."
                                        );
                                      } else if(displaySnap.connectionState == ConnectionState.waiting){
                                        return smallLoading();
                                      }else{
                                        return Text("Error");
                                      }
                                    });
                                }
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              print("there was an error");
              return Loading();
            } else {
              return Loading();
            }
          }),
    );
  }

  Future _title(String data) async {
    dynamic result = await DataBaseService().getDisplayGroup(data);

    if(result == null){
      return "No";
    }else{
      return result;
    }
  }

  Future<void> requestPermissionForIos() async {
    FirebaseMessaging message = FirebaseMessaging.instance;

    NotificationSettings settings = await message.requestPermission(alert: true, sound: true); //request permission from ios user for notification settings to go through.

    print('user granted permisson: ${settings.authorizationStatus}');
  }


}
