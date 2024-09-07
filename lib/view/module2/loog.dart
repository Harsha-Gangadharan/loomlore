import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/validation.dart';
import 'package:flutterlore/view/authentication/widget.dart';
import 'package:flutterlore/view/module2/packege.dart'; // Ensure this import is correct
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignerLoginPage extends StatefulWidget {
  const DesignerLoginPage({super.key});

  @override
  State<DesignerLoginPage> createState() => _DesignerLoginPageState();
}

class _DesignerLoginPageState extends State<DesignerLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> designerLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user UID in SharedPreferences
      await preferences.setString('islogin', credential.user!.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in successfully'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DesignerPackages(indexno: 0), // Ensure this is correct
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error signing in';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    color: Color(0xffCC8381),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  left: 35,
                  top: 130,
                  child: Text(
                    'Welcome\nBack',
                    style: GoogleFonts.poppins(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    UserData(
                      hintext: 'Email',
                      icon: const Icon(Icons.email),
                      fillColor: Colors.white,
                      controller: _emailController,
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
                    TextButton(
                      onPressed: () {
                        // Add forgot password logic here
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            designerLogin();
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
                          "Login",
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
                        onPressed: () {
                          // Add Google sign-in logic here
                        },
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
                          // Add phone sign-in logic here
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
