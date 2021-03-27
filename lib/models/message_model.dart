
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message{
  final String senderid;
  final Timestamp time;
  final String text;
  final List read;

  Message({
    this.senderid,
    this.time,
    this.text,
    this.read
  });

}

