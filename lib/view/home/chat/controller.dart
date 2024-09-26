import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlore/view/home/chat/model.dart';

class ChatService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // Stream to get users from both collections
  Stream<List<Map<String, dynamic>>> getUsers() {
    return db.collectionGroup('registration').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String receiverCollection, String message) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    ChatMessageRoom newMessage = ChatMessageRoom(
      senderID: currentUserId,
      senderemail: currentUserEmail,
      reciverid: receiverID,
      message: message,
      timestamp: timestamp,
    );

    String chatroom = getChatRoomId(currentUserId, receiverID);

    await db.collection('Chatroom')
        .doc(chatroom)
        .collection('message')
        .add(newMessage.toJsone());

    // Optionally update chat metadata for both sender and receiver
    await updateChatMetadata(currentUserId, receiverID, receiverCollection, message, timestamp);
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatroom = getChatRoomId(userId, otherUserId);

    return db.collection('Chatroom')
        .doc(chatroom)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }

  Future<void> updateChatMetadata(String currentUserId, String receiverID, String receiverCollection, String message, Timestamp timestamp) async {
    // Update the chat metadata for the current user
    await db.collection('useregistration')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverID)
        .set({
      'lastMessage': message,
      'timestamp': timestamp,
      'receiverID': receiverID,
      'receiverCollection': receiverCollection,
    });

    // Update the chat metadata for the receiver
    await db.collection(receiverCollection)
        .doc(receiverID)
        .collection('chats')
        .doc(currentUserId)
        .set({
      'lastMessage': message,
      'timestamp': timestamp,
      'senderID': currentUserId,
    });
  }
}
