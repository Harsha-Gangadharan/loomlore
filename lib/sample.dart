

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterlore/firestore.dart';

class samplePage extends StatefulWidget {

  const samplePage({super.key});

  @override
  State<samplePage> createState() => _samplePageState();
}

class _samplePageState extends State<samplePage> {
   TextEditingController nameController =TextEditingController();
  fireStrore b =fireStrore();//object creation for fireStore class
   FirebaseFirestore a=FirebaseFirestore.instance;//instance creation
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 58, 102),
      ),
      body:StreamBuilder(stream: a.collection('userprofile').snapshots(),
       builder: (context,snapshot){
        final userProfile = snapshot.data !.docs;

        return ListView.builder(itemCount:userProfile.length ,itemBuilder: (context,index){
       final userData= userProfile[index].data() as Map<String, dynamic>;
       final userName = userData['name'];
       return ListTile(
        title: Text(userName),
       );
        });
       }
       
       ) ,
    
     
      floatingActionButton: FloatingActionButton(onPressed: (){
        showalertBOx(context);
      },child: Icon(Icons.add),),
    );
  }
//fuction for alert box

showalertBOx(context){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(title: Text("Message for you"),
    content: SizedBox(
      height: 50,width: 100,
      child: TextFormField(
        controller:nameController ,
        decoration: InputDecoration(
        fillColor: Colors.grey[100],filled: true),
        )),
      actions: [
        ElevatedButton(onPressed: (){

         b.saveUserDetailsToFirebase(nameController.text);
          Navigator.pop(context);
        }, child: Text("saved"))
      ],
    );
  },);
}
}