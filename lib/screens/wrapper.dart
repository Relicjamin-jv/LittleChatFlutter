import 'package:flutter/material.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/screens/login_screen_statefull.dart';
import 'package:little_chat/screens/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userInfo>(context);

    //return the auth screen or the home screen
    if(user == null){
      return LoginScreenStateful();
    }else{
      return home();
    }

    return LoginScreenStateful();
  }
}
