import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:little_chat/Service/database.dart';
import 'package:little_chat/Shared/loading.dart';
import 'package:little_chat/screens/uploadScreen.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';



//TODO https://pub.dev/packages/image_picker need to add the configuration for the image picker plugin for ios, or will they be doomed forever
class shed extends StatefulWidget {
  @override
  _shedState createState() => _shedState();
}

class _shedState extends State<shed> {
  List shedUrls = [];

  @override
  void initState() {
    super.initState();
    fetchURL();
  }

  fetchURL() async{
    dynamic result = await DataBaseService().getScheduleURL();
    if(result == null){
      print("Failed to fetchURL");
    }else{
      setState(() {
        shedUrls = result;
      });
    }
  }


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
                itemCount: shedUrls.length <= 3 ? shedUrls.length : 3,
                itemBuilder: (BuildContext context, int index) {
                  String imageUrl = shedUrls[index]['photoUrl'];
                  return ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return _viewScreen(imageUrl);
                        }));
                      },
                      child: Hero(
                        tag: "pop",
                        child: Container(
                          child: Image.network(
                            "https://" + imageUrl,
                            height: 300,
                            loadingBuilder:(context, child, progress){
                              return progress == null ? child : LinearProgressIndicator(value: (progress.cumulativeBytesLoaded/progress.expectedTotalBytes));
                            },
                          ),
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
                    imageProvider: NetworkImage("https://" + image)
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
