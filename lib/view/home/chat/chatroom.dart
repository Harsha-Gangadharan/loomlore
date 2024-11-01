import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/chat/message.dart';

class ChatRoomScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String? currentUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: currentUid == null
          ? Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chats')
                  .where('participants', arrayContains: currentUid)
                  .orderBy('lastMessageTimestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No chats available"));
                }

                var chatRooms = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    var chatRoom = chatRooms[index].data() as Map<String, dynamic>;
                    var designerUid = chatRoom['designerUid'];
                    var lastMessage = chatRoom['lastMessage'] ?? '';
                    var lastMessageTimestamp = chatRoom['lastMessageTimestamp'] as Timestamp?;

                    return FutureBuilder<DocumentSnapshot>(
                      future: firestore.collection('designeregistration').doc(designerUid).get(),
                      builder: (context, designerSnapshot) {
                        if (!designerSnapshot.hasData || !designerSnapshot.data!.exists) {
                          return SizedBox.shrink();
                        }

                        var designerData = designerSnapshot.data!;
                        String designerName = designerData['username'] ?? 'Unknown Designer';
                        String designerImage = designerData['image'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: designerImage.isNotEmpty
                                ? NetworkImage(designerImage)
                                : AssetImage('assets/person.jpeg') as ImageProvider,
                          ),
                          title: Text(designerName),
                          subtitle: Text(lastMessage),
                          trailing: lastMessageTimestamp != null
                              ? Text(formatTimestamp(lastMessageTimestamp))
                              : SizedBox.shrink(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageScreen(
                                  receiverID: designerUid,
                                  receiverEmail: designerData['email'],
                                  receiverCollection: 'designeregistration',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  // Format timestamp into a readable time (HH:mm format)
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
