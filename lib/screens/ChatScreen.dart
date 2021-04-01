import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:little_chat/Service/database.dart';
import 'package:little_chat/Service/image.dart';
import 'package:little_chat/Shared/loading.dart';
import 'package:little_chat/Shared/smallLoading.dart';
import 'package:little_chat/models/message_model.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class chatScreen extends StatefulWidget {
  String user;
  String group;
  String guid;
  String displayName;

  chatScreen({this.user, this.group, this.guid, this.displayName});

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  Message message;
  ScrollController _scrollController = new ScrollController();
  TextEditingController messageText = new TextEditingController();
  File _image;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.group),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where('groupUid', isEqualTo: widget.guid)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  }
                  if (snapshot.hasData) {
                    DataBaseService()
                        .updateReadMessage(widget.displayName, widget.guid);
                    return Container(
                      child: ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 15.0),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(snapshot.data.docs[index]['text']);
                            Message message = new Message(
                                senderid: snapshot.data.docs[index]['sentBy'],
                                time: snapshot.data.docs[index]['time'],
                                text: snapshot.data.docs[index]['text'],
                                read: snapshot.data.docs[index]['read']);
                            bool isMe = message.senderid == widget.user ?? null;
                            return _buildMessage(message, isMe);
                          }),
                    );
                  } else {
                    return Text("");
                  }
                }),
          ),

          _image != null ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                child: _image == null ? Text("") : Image.file(_image),
              ),
              _image != null ? TextButton(onPressed: () {
                setState(() {
                  _image = null;
                });
              }, child: Icon(Icons.clear, color: Colors.red,)) : Text(""),
            ],
          ) : Text(""),


          SizedBox(
            height: 4,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            height: 70.0,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.photo,
                      ),
                      iconSize: 25.0,
                      color: Colors.red[600],
                      onPressed: () => {
                        imageService().getImage().then((value) => {
                          setState((){
                            _image = value;
                          }),
                            }),
                      },
                    ),
                    Expanded(
                        child: TextField(
                      controller: messageText,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {},
                      decoration: InputDecoration.collapsed(
                        hintText: "Send a message",
                      ),
                    )),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                      ),
                      iconSize: 25.0,
                      color: Colors.red[600],
                      onPressed: () => {
                        if(messageText.text.isNotEmpty){
                          DataBaseService().setMessageData(
                              widget.user, messageText.text, DateTime.now(), [], widget.guid),
                          messageText.text = "",
                        },
                        if(_image != null){
                          setState((){
                            _image = null;
                          }),
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message, bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.red[200] : Colors.red[50],
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0))
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
      ),
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder(
                  future: _whoSent(message.senderid),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Text("Error");
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }
                    if (snap.hasData) {
                      return Text(
                        snap.data['displayName'] + " ",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    } else {
                      return smallLoading();
                    }
                  }),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _formatTime(message.time),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Visibility(
                  visible: isMe
                      ? message.read.length >= 2
                      : message.read.length == -1,
                  child: Icon(
                    Icons.check,
                    size: 15.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Future _whoSent(String senderid) async {
    try {
      dynamic result = await DataBaseService().getDisplayName(senderid);
      if (result == null) {
        return Text("Failed");
      } else {
        return result;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String _formatTime(Timestamp time) {
    String formattedTime = '';

    String formattedTimeDay = DateFormat.E().format(time.toDate());
    String formattedTimeNDay = DateFormat.d().format(time.toDate());
    String formattedTimeJM = DateFormat.jm().format(time.toDate());

    formattedTime =
        formattedTimeDay + " " + formattedTimeNDay + ", " + formattedTimeJM;

    return formattedTime;
  }
}

_buildMessageComposer(String user, String guid) {
  TextEditingController message = new TextEditingController();
  File _image;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    height: 70.0,
    color: Colors.white,
    child: Column(
      children: [
        Container(
          child: _image == null ? Text("") : Image.file(_image),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.photo,
              ),
              iconSize: 25.0,
              color: Colors.red[600],
              onPressed: () => {
                imageService().getImage().then((value) => {
                      _image = value,
                    }),
              },
            ),
            Expanded(
                child: TextField(
              controller: message,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: "Send a message",
              ),
            )),
            IconButton(
              icon: Icon(
                Icons.send,
              ),
              iconSize: 25.0,
              color: Colors.red[600],
              onPressed: () => {
                DataBaseService().setMessageData(
                    user, message.text, DateTime.now(), [], guid),
                message.text = "",
              },
            ),
          ],
        ),
      ],
    ),
  );
}
