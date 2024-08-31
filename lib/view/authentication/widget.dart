import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final String hintext;
  final Icon icon;
  final bool obscureText;
  final Color fillColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;
 final TextInputType? keyboardType;
  const UserData({
    Key? key,
    required this.hintext,
    required this.icon,
    this.obscureText = false,
    required this.fillColor,
    required this.controller,
    this.validator,
     this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
       keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hintext,
        labelStyle: TextStyle(fontSize: 18),
        prefixIcon: icon,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
