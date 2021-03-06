import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/Service/database.dart';
import 'package:little_chat/Shared/loading.dart';

class uploader extends StatefulWidget {
  final File file;

  uploader({Key key, this.file}) : super(key: key);

  @override
  _uploaderState createState() => _uploaderState();
}

class _uploaderState extends State<uploader> {
  final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "gs://littlechat-76a32.appspot.com");
  UploadTask task;
  double progressState = 0.0;
  String finalPath = '';
  String downloadUrl = '';
  DateTime uploadTime;



  @override
  Widget build(BuildContext context) {
    if(task != null){
      return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
          builder: (BuildContext context, snapshot){
          if(snapshot.hasData){
            double progressPercent = snapshot.data.bytesTransferred / snapshot.data.totalBytes;
            if(snapshot.data.state.toString() == "TaskState.success") {
              downloadUrL();
              print(downloadUrl);
            }
            return Column(
              children: [
                if(snapshot.data.state.toString() == "TaskState.success")
                  Text("Success"),
                LinearProgressIndicator(value: progressPercent,),
              ],
            );
          }else if(snapshot.hasError){
            return Text("Error");
          }else{
            return Loading();
          }
          });
    } else{
      return TextButton.icon(onPressed: (){
        _startUpload();
        }, icon: Icon(Icons.cloud_upload), label: Text("Upload"));
    }
  }

  void _startUpload(){
    uploadTime = DateTime.now();
    String filepath = 'scheduleImages/$uploadTime.png';
    finalPath = filepath; //takes the value and if successful up at the top it will add it to firestore for metadata for it to be called later on to then call a network image
    setState(() {
      task = storage.ref().child(filepath).putFile(widget.file);
    });
    downloadUrL();
    print(downloadUrl);
  }

  Future downloadUrL() async{
    for(var i = 0; i < 4; i++) {
      downloadUrl =
      await storage.ref(finalPath).getDownloadURL().whenComplete(() =>
      {
        if(downloadUrl == ''){
          downloadUrL()
        } else
          {
            DataBaseService().updateScheduleData(
                downloadUrl.substring(8), downloadUrl.substring(75), uploadTime)
          }
      });
    }
  }

}
