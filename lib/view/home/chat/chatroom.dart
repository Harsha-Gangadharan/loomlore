import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/bottomnavi.dart';
import 'package:flutterlore/view/home/chat/controller.dart';
import 'package:flutterlore/view/home/chat/message.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Users',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(child: buildUserList(searchQuery)),
          ],
        ),
      ),
      bottomNavigationBar: MyNav(
        index: 0,
        onTap: (index) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Packages(indexNum: index),
            ),
          );
        },
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      ),
    );
  }

  Widget buildUserList(String searchQuery) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ChatService().getUsers(), // Ensure this returns a Stream<List<Map<String, dynamic>>>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        }

        final filteredUsers = snapshot.data!
            .where((user) => user['username'].toString().toLowerCase().contains(searchQuery))
            .toList();

        return ListView(
          children: filteredUsers
              .map<Widget>((userData) => buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Widget buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != getCurrentUser()!.email) {
      return UserTile(
        userData: userData,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                receiverID: userData['id'],
                receiverEmail: userData['email'],
                receiverCollection: 'designeregistration',  // Specify collection if needed
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

class UserTile extends StatelessWidget {
  final Map<String, dynamic> userData;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.userData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userData['image']),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData['username']),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Chatroom')
                        .doc(getChatRoomId(FirebaseAuth.instance.currentUser!.uid, userData['id']))
                        .collection('message')
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        var lastMessage = snapshot.data!.docs.first;
                        return Text(
                          lastMessage['message'] ?? 'No message content',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        );
                      } else {
                        return Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getChatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join('_');
  }
}
