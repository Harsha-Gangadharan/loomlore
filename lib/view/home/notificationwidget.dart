import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final IconData? trailingIcon;

  const NotificationTile({
    required this.leadingIcon,
    required this.text,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        size: 24.0,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(text),
          ),
          if (trailingIcon != null)
            Icon(
              trailingIcon,
              color: Colors.blue,
              size: 16.0,
            ),
        ],
      ),
    );
  }
}