import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/runwaywidget.dart';

class RunwayPage extends StatefulWidget {
  const RunwayPage({super.key});

  @override
  State<RunwayPage> createState() => _RunwayPageState();
}

class _RunwayPageState extends State<RunwayPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user styles and associated user details with status 'public'
  Future<List<Map<String, dynamic>>> _fetchUserStyles() async {
    List<Map<String, dynamic>> fashionItems = [];

    // Fetch only documents where 'status' is 'public' from 'userstyles' collection
    QuerySnapshot userStylesSnapshot = await _firestore
        .collection('userstyles')
        .where('status', isEqualTo: 'public')
        .get();

    for (var doc in userStylesSnapshot.docs) {
      String uid = doc['uid']; // Fetch UID from userstyles document

      // Fetch user details from 'useregistration' collection using the UID
      DocumentSnapshot userDoc =
          await _firestore.collection('useregistration').doc(uid).get();
      if (userDoc.exists) {
        fashionItems.add({
          'imageUrl': doc['productimage'], // Fetching the product image field from userstyles
          'username': userDoc['username'], // Username from useregistration
          'profilePic': userDoc['image'], // Profile picture from useregistration
          'description': doc['category'], // Fetching the category field from userstyles
          'productid': doc['productId'], // Fetching the productId field from userstyles
        });
      }
    }
    return fashionItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'asset/fashion.png',
          height: 50, // Adjust the height if needed
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUserStyles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No styles available'));
          }

          final fashionItems = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: fashionItems.length,
              itemBuilder: (context, index) {
                final item = fashionItems[index];

                return FashionItem(
                  imageUrl: item['imageUrl'], // Product image from Firestore
                  username: item['username'], // Username from useregistration
                  profilePic: item['profilePic'], // Profile picture from useregistration
                  description: item['description'], // Category from userstyles
                  productId: item['productid'], // Product ID from userstyles
                  image: 'asset/fashion.png', // Static or can be replaced dynamically
                );
              },
            ),
          );
        },
      ),
    );
  }
}
