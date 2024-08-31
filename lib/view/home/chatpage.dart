import 'package:flutter/material.dart';

import 'package:flutterlore/view/home/chatwidget.dart';




class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              hintText: "Search . . . .",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          buildUserItem(context,"James Anderson", "okay well done", "asset/jame.jpeg"),
          buildUserItem(context,"John Azzi", "That is nice man", 'asset/person.jpeg'),
          buildUserItem(context,"Aleena Peter", "8:03", "asset/aleena.jpeg"),
          buildUserItem(context,"Eric William", "8:05", "asset/eric.jpeg"),
        ],
      ),
    );
  }

}