import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterlore/view/authentication/authservice.dart';
import 'package:flutterlore/view/authentication/login.dart';
import 'package:flutterlore/view/authentication/phonelogin.dart';
import 'package:flutterlore/view/authentication/validation.dart';
import 'package:flutterlore/view/authentication/widget.dart';
import 'package:flutterlore/view/home/bottomnavi.dart';

import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailIdController = TextEditingController();
  bool _obscureText = true;
final FirebaseAuthService _authService = FirebaseAuthService();
 

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Packages(indexNum: 0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xffCC8381),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                                           SizedBox(height: 20),
                      UserData(
                        hintext: 'Username',
                        icon: Icon(Icons.account_circle),
                        fillColor: Colors.white,
                        controller: _usernameController,
                        validator: Validator.validateUsername,
                      ),
                      SizedBox(height: 20),
                      UserData(
                        hintext: 'Email',
                        icon: Icon(Icons.email),
                        fillColor: Colors.white,
                        controller: _emailIdController,
                        validator: Validator.validateEmail,
                      ),
                      SizedBox(height: 20),
                     UserData(
  hintext: 'Password',
  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
  fillColor: Colors.white,
  controller: _passwordController,
  obscureText: _obscureText,
  validator: Validator.validatePassword,
),

                    

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffCC8381),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "or",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.g_translate,
                            color: Color(0xffCC8381),
                          ),
                          label: Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Color(0xffCC8381),
                              fontSize: 18,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            side: BorderSide(color: Color(0xffCC8381)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhoneLogin()),
      );
                          },
                          icon: Icon(
                            Icons.phone,
                            color: Color(0xffCC8381),
                          ),
                          label: Text(
                            "Continue with Phone Number",
                            style: TextStyle(
                              color: Color(0xffCC8381),
                              fontSize: 18,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            side: BorderSide(color: Color(0xffCC8381)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffCC8381),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Future<void> signin() async {
  String name = _usernameController.text;
  String email = _emailIdController.text;
  String password = _passwordController.text;

  User? user = await _authService.signInWithEmailAndPassword(email, password);
  if (user != null) {
    print("found");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Packages(indexNum: 0)),
    );
  } else {
    print("error");
  }
}

}
