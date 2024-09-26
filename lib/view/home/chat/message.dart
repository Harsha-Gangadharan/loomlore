import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/chat/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String receiverCollection; // Add this field to determine the receiver's collection

  MessageScreen({
    super.key,
    required this.receiverID,
    required this.receiverEmail,
    required this.receiverCollection , // Required parameter
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ChatService chatService = ChatService();
  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
        widget.receiverID,
        widget.receiverCollection,
        messageController.text,
      );
      messageController.clear();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverEmail}'),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),
          buildUserInput(),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    String senderId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: chatService.getMessages(senderId, widget.receiverID),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: snapshot.data!.docs.map((doc) => buildMessage(doc)).toList(),
          ),
        );
      },
    );
  }

  Widget buildMessage(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == FirebaseAuth.instance.currentUser!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  Widget buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green[200] : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: isCurrentUser ? Radius.circular(12) : Radius.circular(0),
          bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(12),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
