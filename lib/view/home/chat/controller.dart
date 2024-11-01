import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterlore/view/home/chat/model.dart';

class ChatService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // Stream to get users from both collections
  Stream<List<Map<String, dynamic>>> getUsers() {
    return db.collectionGroup('useregistration').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String receiverCollection, String message) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new chat message
    ChatMessageRoom newMessage = ChatMessageRoom(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Generate a unique chatroom ID based on the two user IDs
    String chatroomId = getChatRoomId(currentUserId, receiverID);

    // Add the new message to the chatroom
    await db.collection('chats')  // Ensure collection name is consistent
        .doc(chatroomId)
        .collection('messages')
        .add(newMessage.toJson());

    // Update chat metadata for both users
    await updateChatMetadata(currentUserId, receiverID, receiverCollection, message, timestamp);
  }

  // Stream to get messages between two users
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatroomId = getChatRoomId(userId, otherUserId);

    return db.collection('chats')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Generate chatroom ID by combining and sorting the two user IDs
  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();  // Sort to ensure same order of IDs for any conversation
    return ids.join('_');
  }

  // Update the metadata for the chat
  Future<void> updateChatMetadata(String currentUserId, String receiverID, String receiverCollection, String message, Timestamp timestamp) async {
    // Update the chat metadata for the current user
    await db.collection('chats')  // Centralized chatroom collection
        .doc(getChatRoomId(currentUserId, receiverID))
        .set({
      'lastMessage': message,
      'timestamp': timestamp,
      'participants': [currentUserId, receiverID],
    }, SetOptions(merge: true));  // Use merge to update only the new fields

    // Update the chat metadata for the receiver
    await db.collection('chats')
        .doc(getChatRoomId(currentUserId, receiverID))
        .set({
      'lastMessage': message,
      'timestamp': timestamp,
      'participants': [currentUserId, receiverID],
    }, SetOptions(merge: true));
  }
}
