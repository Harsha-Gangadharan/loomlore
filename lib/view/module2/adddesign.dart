import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/module2/packege.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDesignPage extends StatefulWidget {
  @override
  State<AddDesignPage> createState() => _AddDesignPageState();
}

class _AddDesignPageState extends State<AddDesignPage> {
  bool _isFormValid() {
    return selectedCategory.isNotEmpty &&
       
        descriptionController.text.isNotEmpty;
  }

  final _auth = FirebaseAuth.instance;
  
  final descriptionController = TextEditingController();
  File? uploadImage;
  List<bool> isSelected = [false, false, false, false, false,];
  
  String selectedCategory = '';

  Future<void> productTable() async {
  try {
    String uid = _auth.currentUser!.uid;
    var docRef = FirebaseFirestore.instance.collection('productdetails').doc();

    String docId = docRef.id;

    // Initialize image URL variable
    String imageUrl = '';

    // Upload image to Firebase Storage if present
    if (uploadImage != null) {
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('productimage/product_$docId')
          .putFile(uploadImage!, metadata);

      TaskSnapshot snapshot = await uploadTask;

      // Ensure upload was successful
      if (snapshot.state == TaskState.success) {
        imageUrl = await snapshot.ref.getDownloadURL();
      } else {
        throw ('Image upload failed.');
      }
    }

    // Save product details to Firestore, including the image URL
    await docRef.set({
      'description': descriptionController.text,
      'productimage': imageUrl,
      'uid': uid,
      'category': selectedCategory,
      'productId': docId,
      'Likes': [],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DesignerPackages(indexno: 0)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add product: $e')),
    );
  }
}

  Future<void> _pickedImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    setState(() {
      uploadImage = File(pickedImage.path);
    });
  }
  //  Future<void> _uploadImage() async {
  //   if (uploadImage != null) {
  //     SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
  //     final currenttime = TimeOfDay.now();
  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref()
  //         .child('shoapimage/shoap$currenttime')
  //         .putFile(uploadImage!, metadata);
  //     TaskSnapshot snapshot = await uploadTask;
  //     String url = await snapshot.ref.getDownloadURL();
  //     String id = _auth.currentUser!.uid;
  //     await FirebaseFirestore.instance
  //         .collection('productdetails')
  //         .doc(id)
  //         .update({'image': url});
  //   }
  // }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Photo Library'),
              onTap: () {
                Navigator.of(context).pop();
                _pickedImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickedImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffCC8381),
        title: Text(
          'ADD DESIGN',
          style: GoogleFonts.inknutAntiqua(
            fontSize: 26,
            color: Color.fromARGB(255, 14, 14, 14),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _showImageSourceActionSheet(context);
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: uploadImage != null
                            ? FileImage(uploadImage!)
                            : AssetImage('asset/post.jpg') as ImageProvider<Object>,
                      ),
                      shape: BoxShape.rectangle,
                      color: Colors.grey[300],
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: IconButton(
                      onPressed: () {
                        _showImageSourceActionSheet(context);
                      },
                      icon: Icon(Icons.add_a_photo_rounded),
                      color: Colors.black,
                      iconSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          labelText: 'Description',
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                   Wrap(
  spacing: 20.0,
  runSpacing: 20.0,
  alignment: WrapAlignment.center,
  children: [
    for (int i = 0; i < categories.length; i++)   
      ElevatedButton(
        onPressed: () {
          setState(() {
            _selectCategory(i, categories[i]);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected[i]
              ? Color(0xffCC8381)
              : const Color.fromARGB(142, 123, 120, 121),
        ),
        child: Text(
          categories[i],
          style: TextStyle(color: Colors.black),
        ),
      ),
  ],
),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_isFormValid()) {
                      productTable();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all required fields.')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final List<String> categories = [
    'officewear',
    'party wear',
    'casual wear',
    'western',
    'Traditional',
  ];

   void _selectCategory(int index, String category) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      isSelected[buttonIndex] = buttonIndex == index;
      
    }
    selectedCategory = category;
  }
}
