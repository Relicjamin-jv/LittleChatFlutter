import 'package:flutter/material.dart';
import 'package:little_chat/models/shed_model.dart';
import 'package:photo_view/photo_view.dart';

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
              //TODO add function for the user to use upload a network image
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
                          image: AssetImage(images[index].urlImage),
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
