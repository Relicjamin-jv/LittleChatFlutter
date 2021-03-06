import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:little_chat/screens/login_screen.dart';
import 'package:little_chat/screens/login_screen_statefull.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context); //this sets the current focus to be what ever the context is

        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){ //stop from throwing an exception when there is no primary focus etc clicking a non-focusable widget twice
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: "Little Chat",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red[800],
        ),
        home: LoginScreenStateful(),
      ),
    );
  }
}