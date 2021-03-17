
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:little_chat/models/message_model.dart';
import 'home.dart';


class chatScreen extends StatefulWidget {

  String user;

  chatScreen({this.user});

  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
            widget.user
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // child: ListView.builder(
              //   reverse: true,
              //   padding: EdgeInsets.only(top: 15.0),
              //   itemCount: chats.length,
              //     itemBuilder: (BuildContext context, int index) {
              //     bool isMe = chats[index].senderid == widget.user;
              //     final Message message = chats[index];
              //     return _buildMessage(message, isMe);
              // }),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message, bool isMe) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Colors.red[200] : Colors.red[50],
        borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)) :
        BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
      ),
      margin: isMe ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0) : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                message.time,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Visibility(
                    visible: message.unread,
                    child: Icon(
                      Icons.check,
                      size: 15.0,
                    ),
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
}

_buildMessageComposer() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    height: 70.0,
    color: Colors.white,
    child: Row(
      children: [
        IconButton(
            icon: Icon(
              Icons.photo,
            ),
            iconSize: 25.0,
            color: Colors.red[600],
            //TODO opening the gallery of the phone
            onPressed: () => null,
        ),
        Expanded(child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
          },
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
          //TODO sending a message to the mothership
          onPressed: () => null,
        ),
      ],
    ),
  );
}

