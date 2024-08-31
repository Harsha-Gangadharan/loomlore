import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/authservice.dart';
import 'package:flutterlore/view/authentication/otpoage.dart';
import 'package:flutterlore/view/authentication/sign.dart';
import 'package:flutterlore/view/authentication/validation.dart';
import 'package:flutterlore/view/authentication/widget.dart';
import 'package:flutterlore/view/authentication/auth.dart';
class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();

  final FirebaseAuthService _authservice = FirebaseAuthService();
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text("Loomlore",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
              const SizedBox(height: 100),
              Column(
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    child: UserData(
                      hintext: 'Password',
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      fillColor: Colors.white,
                      controller: passwordcontroller,
                      obscureText: _obscureText,
                      validator: Validator.validatePassword,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    child: UserData(
                      hintext: 'Phone Number',
                      icon: const Icon(Icons.phone),
                      fillColor: const Color.fromRGBO(241, 243, 245, 1),
                      controller: otpcontroller,
                      keyboardType: TextInputType.number,
                      validator: Validator.validatePhoneNumber,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      _authservice.sendCode(context, otpcontroller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(134, 231, 24, 1),
                      minimumSize: const Size(200, 55),
                    ),
                    child: const Text("Continue",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text("Don’t have an account? Sign up",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
