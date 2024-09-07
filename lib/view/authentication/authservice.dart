

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/otpoage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          print(credential.user);
          print('helloooooo');
      return credential.user;
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email is already in use');
      } else {
        print('An error occurred: ${e.code}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found with this email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      } else {
        print('An error occurred: ${e.code}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return null;
  }
  
Future<void> sendCode(context, phoneNumber) async {
    try {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91 ${phoneNumber}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print("Error : ${e.code}");
        },
        codeSent: (String vid, int? token) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OtpPage(vid: vid)));
        },
        codeAutoRetrievalTimeout: (vid) {});
  }on FirebaseAuthException catch (e) {
    print("jsdjfjjdjsdf");
    print("Erroe Occured : ${e.code}");
  }catch(e){
    print("6544466646464");
    print("Error : ${e.toString()}");
  }
}
}
