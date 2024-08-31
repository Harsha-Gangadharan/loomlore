import 'package:flutter/material.dart';
class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Wishlist',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          SizedBox(width: 48),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/one.jpeg",
  height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('asset/profile.jpg')
                ),
                SizedBox(width: 8),
                Text('John Azzi'),
                SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 16,
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}