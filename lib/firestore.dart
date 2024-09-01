import 'package:cloud_firestore/cloud_firestore.dart';

class fireStrore{
  FirebaseFirestore a=FirebaseFirestore.instance;//instance creation
  Future<void> saveUserDetailsToFirebase(String userName) async{
    try{
      Map<String,dynamic> userDetails ={
        'name': userName,
      };
      await a.collection('user_profile').add(userDetails);

      print('User Data Saved');
    }
    catch(e) {
      print("Error occured:$e");
    }
  }

}