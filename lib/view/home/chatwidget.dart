import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/messagepage.dart';


Widget buildUserItem(BuildContext context, String name, String message, String imagePath) {
  return GestureDetector(
    onTap: () {
     
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessagePage()), 
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 25,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.check_circle, color: Colors.blue, size: 15),
                  ],
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.videocam),
          SizedBox(width: 10),
          Icon(Icons.more_vert),
        ],
      ),
    ),
  );
}