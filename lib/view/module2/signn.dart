import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/phonelogin.dart';
import 'package:flutterlore/view/authentication/validation.dart';
import 'package:flutterlore/view/authentication/widget.dart';
import 'package:flutterlore/view/module2/loog.dart';
import 'package:flutterlore/view/module2/packege.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/bottomnavi.dart';

class DesignerRegistrationPage extends StatefulWidget {
  const DesignerRegistrationPage({super.key});

  @override
  State<DesignerRegistrationPage> createState() => _DesignerRegistrationPageState();
}

class _DesignerRegistrationPageState extends State<DesignerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _phoneController = TextEditingController(); // Phone number controller
  bool _obscureText = true;
  File? selectedImage;
  String email = '';
  String password = '';

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  Future<void> _uploadUserDetails(String uid) async {
    String imageUrl = '';

    if (selectedImage != null) {
      // Upload image to Firebase Storage
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('userimages/$uid')
          .putFile(selectedImage!);

      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    // Save user details in Firestore
    await FirebaseFirestore.instance.collection('designeregistration').doc(uid).set({
      "username": _usernameController.text,
      "email": _emailIdController.text,
      "password": _passwordController.text,
      "phone": _phoneController.text, // Add phone number to Firestore
      "image": imageUrl,
      "id": uid,
    });
  }

  Future<void> registration() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;
      preferences.setString('islogin', uid);

      await _uploadUserDetails(uid);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DesignerPackages(indexno: 0),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
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
                child: GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        selectedImage != null ? FileImage(selectedImage!) : null,
                    child: selectedImage == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
                        : null,
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
                      hintext: 'Phone Number',
                      icon: const Icon(Icons.phone),
                      fillColor: Colors.white,
                      controller: _phoneController,
                      validator: Validator.validatePhoneNumber, // Add a validator for phone
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = _emailIdController.text;
                              password = _passwordController.text;
                            });
                            registration();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Invalid username, password, email, or phone number'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
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
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DesignerLoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffCC8381),
                          minimumSize: const Size(double.infinity, 50),
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
                    const SizedBox(height: 20),
                  
          ]
                ),
              ),
            )]
            )));
  
  }
}
