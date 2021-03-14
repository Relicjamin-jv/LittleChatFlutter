import 'package:flutter/material.dart';
import 'package:little_chat/Service/auth.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              onPressed: (){
                AuthService().signOut();
              },
              icon: Icon(
                Icons.exit_to_app_sharp,
              ),
              label: Text("sign out"))
        ],
      ),
    );
  }
}


