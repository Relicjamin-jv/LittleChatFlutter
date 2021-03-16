
import 'package:firebase_auth/firebase_auth.dart';

class Message{
  final String sender;
  final String time;
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread
  });

}

//Some sample messages to set up just to get the UX set up

List<Message> chats = [
  Message(
    sender: "Collin",
    time: "5:00 AM",
    text: "Hello, you're late for work",
    unread: true,
  ),
  Message(
    sender: "Bill",
    time: "5:00 AM",
    text: "my bad I'll be right their",
    unread: false,
  ),
  Message(
    sender: "Collin",
    time: "5:00 AM",
    text: "No problem, taking an L sometimes happens",
    unread: true,
  ),
  Message(
    sender: "Bill",
    time: "5:00 AM",
    text: "Sad times",
    unread: true,
  ),



];