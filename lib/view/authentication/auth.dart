import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/otpoage.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
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