import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/Service/auth.dart';
import 'package:little_chat/Service/database.dart';
import 'package:little_chat/Shared/loading.dart';

class LoginScreenStateful extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreenStateful> {
  bool _isHidden = true;
  bool _remember = false;
  bool _loading = false;
  String _error = "";
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passWordController = new TextEditingController();
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red, Colors.redAccent],
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(50),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image(
                    image: AssetImage(
                      "Assets/Images/Logo.png",
                    ),
                    height: 120,
                    width: 120,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(12),
                child: TextField(
                  onTap: () {
                    setState(() {
                      _error = "";
                    });
                  },
                  controller: userNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Username",
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: TextField(
                  onTap: (){
                    setState(() {
                      _error = "";
                    });
                  },
                  controller: passWordController,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                        size: 25,
                      ),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CheckboxListTile(
                    title: Text(
                      "Remember me?"
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: Colors.black45,
                    value: _remember,
                    onChanged: (bool newValue){
                      setState(() {
                        _remember = newValue;
                      });
                    },
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });
                    dynamic loginResult = await _auth.signInUsernamePassword(userNameController.text, passWordController.text);
                    if(loginResult == null){
                      setState(() {
                        _loading = false;
                        _error = "Wrong Username/Password";
                      });
                      print("Wrong user/password");
                    }else{
                      print("Right password");
                    }
                    //print(AuthService().user); old subscription based code callers
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _error != "",
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    _error,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

}





