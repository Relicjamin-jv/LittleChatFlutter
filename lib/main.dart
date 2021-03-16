import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:little_chat/Service/auth.dart';
import 'package:little_chat/models/userInfo.dart';
import 'package:little_chat/screens/login_screen.dart';
import 'package:little_chat/screens/login_screen_statefull.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:little_chat/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
  ]);
  runApp(MyApp());
}


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
      child: StreamProvider<userInfo>.value(
        value: AuthService().authState,
        child: MaterialApp(
          title: "Little Chat",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.red[800],
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}