
import 'package:firebase_auth/firebase_auth.dart';

class Message{
  final String senderid;
  final String time;
  final String text;
  final bool unread;

  Message({
    this.senderid,
    this.time,
    this.text,
    this.unread
  });

}

//Some sample messages to set up just to get the UX set up

List<Message> chats = [

];