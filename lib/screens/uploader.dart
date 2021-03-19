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

  // Future<void> handleUploadTask() async{
  //   String file = 'uploadSchedule/${DateTime.now()}.png';
  //   task = storage.ref().child(file).putFile(widget.file);
  //   task.snapshotEvents.listen((TaskSnapshot snapshot) {
  //     print("Task state: ${snapshot.state}");
  //     print("Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %");
  //     setState(() {
  //       progressState = (snapshot.bytesTransferred / snapshot.totalBytes);
  //     });
  //   }, onError: (e){
  //     print(task.snapshot);
  //     if(e.code == 'permission-denied'){
  //       print("user does not have permission");
  //     }
  //   });
  //
  //   try{
  //     await task;
  //   }on FirebaseException catch (e) {
  //     if ((e.code) == "permission-denied") {
  //       print("user does not have permission");
  //     }
  //   }
  // }

  void _startUpload(){
    String filepath = 'scheduleImages/${DateTime.now()}.png';
    finalPath = filepath; //takes the value and if successful up at the top it will add it to firestore for metadata for it to be called later on to then call a network image
    setState(() {
      task = storage.ref().child(filepath).putFile(widget.file);
    });
    downloadUrL();
    print(downloadUrl);
  }

  Future downloadUrL() async{
    for(var i =0; i < 4; i++) {
      downloadUrl =
      await storage.ref(finalPath).getDownloadURL().whenComplete(() =>
      {
        if(downloadUrl == ''){
          downloadUrL()
        } else
          {
            DataBaseService().updateScheduleData(
                downloadUrl.substring(8), downloadUrl.substring(75))
          }
      });
    }
  }

}
