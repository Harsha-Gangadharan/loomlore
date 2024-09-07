import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/authservice.dart';
import 'package:flutterlore/view/authentication/login.dart';
import 'package:flutterlore/view/authentication/phonelogin.dart';
import 'package:flutterlore/view/authentication/validation.dart';
import 'package:flutterlore/view/authentication/widget.dart';
import 'package:flutterlore/view/home/bottomnavi.dart';
import 'package:flutterlore/view/home/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _auth = FirebaseAuth.instance;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String email = '';
  String password = '';

  Future addFirebase(
      Map<String, dynamic> registeredUserInfoMap, String userId) async {
    return FirebaseFirestore.instance
        .collection('useregistration')
        .doc(userId)
        .set(registeredUserInfoMap);
  }

  registration() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      preferences.setString('islogin', credential.user!.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Success')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Packages(
                indexNum: 0,
              ),));

      String uid = _auth.currentUser!.uid;
      Map<String, dynamic> registerInfoMap = {
        "username": _usernameController.text,
        "email": _emailIdController.text,
        "password": _passwordController.text,
        "image": '',
        "id": uid,
       
      };
      await addFirebase(registerInfoMap, uid);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Details added to Firebase successfully')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Weak password')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already in use')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
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
                                      'Invalid username, password, or email'),
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
                                  builder: (context) => const PhoneLogin()),
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
                                builder: (context) => const LoginPage(),
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
}
