
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message{
  final String senderid;
  final Timestamp time;
  final String text;
  final List read;
  final int type;
  final String photoUrl;

  Message({
    this.senderid,
    this.time,
    this.text,
    this.read,
    this.type,
    this.photoUrl
  });

}

