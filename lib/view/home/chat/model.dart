import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageRoom {
  final String senderID;
  final String senderEmail;  // Updated camelCase for consistency
  final String receiverID;   // Fixed typo: 'reciverid' -> 'receiverID'
  final String message;
  final Timestamp timestamp;

  ChatMessageRoom({
    required this.senderID,
    required this.senderEmail,   // Corrected naming to 'senderEmail'
    required this.receiverID,    // Fixed typo 'reciverid' -> 'receiverID'
    required this.message,
    required this.timestamp,
  });

  // Convert the object to a JSON-compatible map
  Map<String, dynamic> toJson() => {
    'senderID': senderID,
    'senderEmail': senderEmail,   // Corrected name
    'receiverID': receiverID,     // Corrected typo
    'message': message,
    'timestamp': timestamp,
  };
}
