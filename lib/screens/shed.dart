import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:little_chat/models/shed_model.dart';
import 'package:little_chat/screens/uploadScreen.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';



//TODO https://pub.dev/packages/image_picker need to add the configuration for the image picker plugin for ios, or will they be doomed forever
class shed extends StatefulWidget {
  @override
  _shedState createState() => _shedState();
}

class _shedState extends State<shed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Schedule",
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => uploadScreen()));
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  String imageUrl = images[index].urlImage;
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return _viewScreen(imageUrl);
                        }));
                      },
                      child: Hero(
                        tag: "pop",
                        child: Image(
                          image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/littlechat-76a32.appspot.com/o/scheduleImages%2F2021-03-19%2016%3A20%3A06.810280.png?alt=media&token=988a28b0-6b26-4f55-9531-abf05da1b4fc"),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _viewScreen(String image) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Center(
              child: Hero(
                tag: "pop",
                child: Container(
                  child: PhotoView(
                    imageProvider: AssetImage(image)
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
