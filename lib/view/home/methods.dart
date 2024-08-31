import 'package:flutter/material.dart';
Widget buildDressItem({
    required AssetImage imageUrl,
    required bool isPublic,
    String? likes,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: imageUrl,
            height: 120,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          if (isPublic)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up, color: Colors.black),
                SizedBox(width: 4),
                Text(likes ?? ''),
              ],
            ),
          if (!isPublic)
            Text(
              'Private',
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }