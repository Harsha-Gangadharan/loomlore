import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final String receiverID;
  final String receiverEmail;
  final String receiverCollection; // To know if it's a designer or user

  const MessageScreen({
    Key? key,
    required this.receiverID,
    required this.receiverEmail,
    required this.receiverCollection,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  // Fetches the chat messages between the current user and the designer/user
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages() {
    String chatRoomId = getChatRoomId(currentUser!.uid, widget.receiverID);
    return firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Sends a message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    String chatRoomId = getChatRoomId(currentUser!.uid, widget.receiverID);
    String message = messageController.text.trim();

    var messageData = {
      'senderID': currentUser!.uid,
      'receiverID': widget.receiverID,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    messageController.clear();
  }

  // Generate a unique chat room ID
  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) < 0) {
      return '$user1\_$user2';
    } else {
      return '$user2\_$user1';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet."));
                }
                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index].data();
                    bool isSentByCurrentUser = messageData['senderID'] == currentUser!.uid;

                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? Colors.blue[300]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messageData['message'] ?? '',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
