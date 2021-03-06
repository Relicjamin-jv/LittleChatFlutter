import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreenStateful extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreenStateful> {
  bool _isHidden = true;
  bool _remember = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: RaisedButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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





