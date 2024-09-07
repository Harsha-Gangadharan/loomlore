import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutterlore/view/home/creation.dart';
import 'package:flutterlore/view/home/homewidget.dart';
import 'package:flutterlore/view/home/notificationpage.dart';
import 'package:flutterlore/view/home/wishlist.dart';

class DesignerHomePage extends StatefulWidget {
  const DesignerHomePage({Key? key}) : super(key: key);

  @override
  State<DesignerHomePage> createState() => _DesignerHomePageState();
}

class _DesignerHomePageState extends State<DesignerHomePage> {
  WidgetHome a = WidgetHome();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
String selectedCategory = "All Items"; 
  // Method to get user profile by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getSelectedUserProfile(String id) async {
    try {
      return await firestore
          .collection("designeregistration")
          .doc(id)
          .get();
    } catch (e) {
      // Handle errors here
      print("Error getting user profile: $e");
      throw e;
    }
  }

  // Stream to get all posts filtered by category (if necessary)
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts(String selectedCategory) {
    if (selectedCategory.isEmpty) {
      // Return an empty stream if no category is selected
      return Stream.empty();
    } else {
      return firestore
          .collection("productdetails")
          .where('category', isEqualTo: selectedCategory) // Filter by category
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: a.buildAppBar(context),
      drawer: buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: firestore
                  .collection('designeregistration')
                  .doc(currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.hasError) {
                  return const Center(child: Text('No data available'));
                }
                DocumentSnapshot data = snapshot.data!;
                if (!data.exists) {
                  return const Center(child: Text('User not found'));
                }

                String userName = data['username'] ?? 'No Name';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, Welcome 👋", style: GoogleFonts.poppins(fontSize: 20)),
                    Text(userName,
                        style: GoogleFonts.poppins(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
            a.buildSearchBar(),
            const SizedBox(height: 20),
              const SizedBox(height: 20),
            a.buildCategoryTabs((category) {
              setState(() {
                selectedCategory = category; // Set selected category
              });
            }, selectedCategory), // Pass callback and selected category
            const SizedBox(height: 20),
            Expanded(child: a.buildProductGrid(selectedCategory)),
          ],
        ),
      ),
    );
  }

  
   Drawer buildDrawer(){
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('useregistration') // Correct collection name
                    .doc(currentUser?.uid) // Use current user's ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(child: Text('No data available'));
                  }
                  DocumentSnapshot data = snapshot.data!;
                  if (!data.exists) {
                    return const Center(child: Text('User not found'));
                  }
                  // Access data fields here
                  String userName = data['username'] ?? 'No Name';
                  String userEmail = data['email'] ?? 'No Email';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("asset/profile.jpg"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userEmail,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('My Creation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCreationPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Wishlist'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Complaints'),
              onTap: () {
                _showComplaintDialog(context);
              },
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffd9a0a0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Implement logout functionality
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComplaintDialog(BuildContext context) {
    final TextEditingController complaintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Complaint'),
          content: TextField(
            controller: complaintController,
            decoration: const InputDecoration(hintText: 'Enter your complaint'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String complaint = complaintController.text.trim();
                if (complaint.isNotEmpty) {
                  _submitComplaint(complaint);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitComplaint(String complaint) {
    if (currentUser != null) {
      firestore
          .collection('complaints')
          .doc(currentUser!.uid) // Use current user's ID as document ID
          .set({
        'complaint': complaint,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        // Handle success (e.g., show a success message)
      }).catchError((error) {
        // Handle error (e.g., show an error message)
      });
    }
  }
}
  

