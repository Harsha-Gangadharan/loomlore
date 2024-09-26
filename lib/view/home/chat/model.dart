import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageRoom{
  final String senderID;
  final String senderemail;
  final String reciverid;
  final String message;
  final Timestamp timestamp;



  ChatMessageRoom({
    required this.senderID,
    required this.senderemail,
    required this.reciverid,
    required this.message,
    required this.timestamp,
  });


  Map<String,dynamic>toJsone()=>{
    'senderid':senderID,
    'senderemail':senderemail,
    'reciverid':reciverid,
    'message':message,
    'timestamp':timestamp,
  };
}