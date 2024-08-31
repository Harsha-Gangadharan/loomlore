
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("asset/jame.jpeg"),
            ),
            SizedBox(width: 10),
            Text("James Anderson"),
            SizedBox(width: 5),
            Icon(Icons.check_circle, color: Colors.blue, size: 15),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                _buildSentMessage("Hello! I just see your design and I am very impressed", true),
                _buildReceivedMessage("Wow... Thank you", false),
                _buildSentAudioMessage(true),
                _buildReceivedAudioMessage(false),
                _buildSentMessage("Okay well done", true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String message, bool isSent) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSent ? Colors.white : Colors.pink.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSent ? Colors.grey.shade300 : Colors.transparent),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildReceivedMessage(String message, bool isReceived) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isReceived ? Colors.pink.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildSentAudioMessage(bool isSent) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSent ? Colors.white : Colors.pink.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSent ? Colors.grey.shade300 : Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: Colors.black),
            SizedBox(width: 5),
            Container(
              width: 100,
              height: 20,
              color: Colors.grey.shade300,
              child: Center(
                child: Text(
                  "Audio Waveform",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text("0:17"),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedAudioMessage(bool isReceived) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isReceived ? Colors.pink.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: Colors.black),
            SizedBox(width: 5),
            Container(
              width: 100,
              height: 20,
              color: Colors.grey.shade300,
              child: Center(
                child: Text(
                  "Audio Waveform",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text("0:17"),
          ],
        ),
      ),
    );
  }
}