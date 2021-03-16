import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/Service/auth.dart';
import 'package:little_chat/models/message_model.dart';
import 'package:little_chat/screens/ChatScreen.dart';
import 'package:little_chat/screens/shed.dart';

class home extends StatefulWidget {

  final String user;

  home({this.user});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
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
              title: Text(
                "Schedule"
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => shed())),
            ),
            ListTile(
              leading: Icon(
                Icons.add
              ),
              title: Text(
                "Start a Conversation"
              ),
              //TODO make a recycle screen that allows the user to pick the people who they want to talk to
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline_rounded
              ),
              title: Text(
                "Information"
              ),
              //TODO make a screen that has a short info on the app and contact information
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app_sharp
              ),
              title: Text(
                "Sign out"
              ),
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
          IconButton(
              onPressed: (){
                //TODO add a search function for the user to search for an user
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
          ),
        ],
      ),
      body: Column(
        children: [
          //TODO add the listview based on this video https://www.youtube.com/watch?v=h-igXZCCrrc
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => chatScreen(user: widget.user))),
                    title: Text(chats[index].senderid),
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        '${chats[index].senderid[0]}'
                      ),
                    ),
                    subtitle: Text(
                      chats[index].text
                    ),
                    trailing: Container(
                      child: Column(
                        children: [
                          Text(
                            chats[index].time
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                            child: Visibility(
                              visible: chats[index].unread,
                              child: Icon(
                                Icons.check,
                                size: 15.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
              }),
            ),
          ),
        ],
      ),
    );
  }
}




