import 'package:flutter/material.dart';

class info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Information",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: Text("Hello! If you find any bugs let me know. Some cool stuff to know \n 1. "
          "Nothing is saved to you device, if you try to open the app w/o an internet connection there will be a plethora of errors \n 2. "
          "There is some error correction, however some things I may have missed if you get a big red box restart the app and make sure you have an internet connection \n 3. "
          "IOS, I really couldn't do a lot of testing with it, so it might be quite a bit janky."),
    );
  }
}

