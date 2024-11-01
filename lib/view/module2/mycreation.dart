import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreationPage extends StatefulWidget {
  @override
  _CreationPageState createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future to fetch creations from Firestore where uid matches current user
  Future<List<DocumentSnapshot>> _fetchCreations() async {
    String uid = _auth.currentUser!.uid; // Get the current user's ID

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('productdetails')
        .where('uid', isEqualTo: uid)
        .get(); // Fetch documents where uid matches

    return querySnapshot.docs;
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
            Navigator.pop(context); // Go back
          },
        ),
        title: Text(
          'My Creation',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _fetchCreations(), // Fetch user creations from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading spinner while fetching
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching data')); // Handle any errors
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No creations found')); // If no creations found
            }

            List<DocumentSnapshot> creations = snapshot.data!;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: creations.length,
              itemBuilder: (context, index) {
                var creation = creations[index];
                String imageUrl = creation['productimage'];
                String description = creation['description'];
                String category = creation['category'];
                // String status=creation['status'];

                return buildDressItem(
                  imageUrl: NetworkImage(imageUrl), // Use the fetched product image
                  description: description,
                  category: category,
                  // status: status,
                  // likes: creation['Likes'].length.toString(), // Show number of likes
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Helper method to build each dress item
  Widget buildDressItem({
    required ImageProvider imageUrl,
    required String description,
    required String category,
    // required String status,
    String likes = '0',
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  category,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                // Text(
                //   status,
                //   style: TextStyle(color: Colors.white70, fontSize: 12),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Icon(Icons.favorite, color: Colors.red, size: 16),
                //     Text('$likes likes', style: TextStyle(color: Colors.white)),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
