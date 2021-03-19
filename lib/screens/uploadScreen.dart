import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:little_chat/screens/uploader.dart';

class uploadScreen extends StatefulWidget {
  @override
  _uploadScreenState createState() => _uploadScreenState();
}

class _uploadScreenState extends State<uploadScreen> {
  File _image;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  takeImage();
                }),
            IconButton(
                icon: Icon(Icons.photo),
                onPressed: () {
                  getImage();
                })
          ],
        ),
      ),
      body: FutureBuilder(
        future: retrieveLostData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(_image != null) {
            return ListView(
              children: [
                if (_image != null) ...[
                  Image.file(_image),
                  Row(
                    children: [
                      TextButton(onPressed: () {
                        clear();
                      }, child: Icon(Icons.clear, color: Colors.red,))
                    ],
                  ),
                  uploader(file: _image),
                ],
              ],
            );
          }else{
            return Text("Picture time bby");
          }
        }
      ),
    );
  }

  void clear() {
    setState(() {
      _image = null;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  Future takeImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  Future retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    }
  }
}
