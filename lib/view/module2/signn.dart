import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/authservice.dart'; // Ensure this import is needed
import 'package:flutterlore/view/authentication/login.dart';
import 'package:flutterlore/view/authentication/phonelogin.dart';
import 'package:flutterlore/view/authentication/validation.dart';
import 'package:flutterlore/view/authentication/widget.dart';
import 'package:flutterlore/view/home/bottomnavi.dart';
import 'package:flutterlore/view/module2/loog.dart';
import 'package:flutterlore/view/module2/packege.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignerRegistrationPage extends StatefulWidget {
  @override
  State<DesignerRegistrationPage> createState() => _DesignerRegistrationPageState();
}

class _DesignerRegistrationPageState extends State<DesignerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailIdController = TextEditingController();
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> addFirebase(Map<String, dynamic> registeredUserInfoMap, String userId) async {
    await FirebaseFirestore.instance
        .collection('designeregistration')
        .doc(userId)
        .set(registeredUserInfoMap);
  }

  Future<void> designerRegistration() async {
    if (!_formKey.currentState!.validate()) return; // Ensure form validation

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailIdController.text.trim(),
        password: _passwordController.text.trim(),
      );

      preferences.setString('islogin', credential.user!.uid);

      String uid = credential.user!.uid;
      Map<String, dynamic> registerInfoMap = {
        "username": _usernameController.text.trim(),
        "email": _emailIdController.text.trim(),
        "password": _passwordController.text.trim(),
        "image": '',
        "id": uid,
      };

      await addFirebase(registerInfoMap, uid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DesignerPackages(indexno: 0),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              decoration: const BoxDecoration(
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
                    const SizedBox(height: 20),
                    UserData(
                      hintext: 'Username',
                      icon: const Icon(Icons.account_circle),
                      fillColor: Colors.white,
                      controller: _usernameController,
                      validator: Validator.validateUsername,
                    ),
                    const SizedBox(height: 20),
                    UserData(
                      hintext: 'Email',
                      icon: const Icon(Icons.email),
                      fillColor: Colors.white,
                      controller: _emailIdController,
                      validator: Validator.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    UserData(
                      hintext: 'Password',
                      icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility),
                      fillColor: Colors.white,
                      controller: _passwordController,
                      obscureText: _obscureText,
                      validator: Validator.validatePassword,
                      onTapIcon: _toggleVisibility,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        onPressed: designerRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffCC8381),
                          minimumSize: const Size(double.infinity, 50),
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
                    const SizedBox(height: 20),
                    const Text(
                      "or",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_translate,
                          color: Color(0xffCC8381),
                        ),
                        label: const Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Color(0xffCC8381),
                            fontSize: 18,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Color(0xffCC8381)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PhoneLogin(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.phone,
                          color: Color(0xffCC8381),
                        ),
                        label: const Text(
                          "Continue with Phone Number",
                          style: TextStyle(
                            color: Color(0xffCC8381),
                            fontSize: 18,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Color(0xffCC8381)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DesignerLoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
