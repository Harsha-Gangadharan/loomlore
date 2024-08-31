import 'package:flutter/material.dart';

import 'package:flutterlore/view/home/notificationwidget.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
           
          },
        ),
        title: Text('Notification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NotificationTile(
              leadingIcon: Icons.notifications,
              text:
                  'Teal Velvet Asymmetrical Gown added to your wishlist',
            ),
            NotificationTile(
              leadingIcon: Icons.account_circle,
              text: 'James Anderson commented on your design',
              trailingIcon: Icons.verified,
            ),
            NotificationTile(
              leadingIcon: Icons.notifications,
              text: 'You published a new design',
            ),
          ],
        ),
      ),
    );
  }
}