

import 'package:flutter/material.dart';

class FashionItem extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String likes;
  final String profilePic;

  FashionItem({
    required this.imageUrl,
    required this.username,
    required this.likes,
    required this.profilePic, required String image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(profilePic),  
            ),
            title: Text(username),
            trailing: Icon(Icons.more_vert),
          ),
          Expanded(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(width: 4),
                    Text(likes),
                  ],
                ),
                Icon(Icons.chat_bubble_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
