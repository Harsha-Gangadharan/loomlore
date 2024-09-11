import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/login.dart';
import 'package:flutterlore/view/home/creation.dart';
import 'package:flutterlore/view/home/homewidget.dart'; // Assuming WidgetHome is defined here
import 'package:flutterlore/view/home/notificationpage.dart';
import 'package:flutterlore/view/home/settings.dart';
import 'package:flutterlore/view/home/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WidgetHome widgetHome = WidgetHome(); // Instance of WidgetHome
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
 final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedCategory = "All Items"; // Default selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widgetHome.buildAppBar(context), // Use widgetHome to call AppBar
      drawer: buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widgetHome.buildGreeting(), // Greeting
            widgetHome.buildSearchBar(), // Search Bar
            const SizedBox(height: 20),
            widgetHome.buildCategoryTabs((category) {
              setState(() {
                selectedCategory = category; // Set selected category
              });
            }, selectedCategory), // Pass callback and selected category
            const SizedBox(height: 20),
            Expanded(child: widgetHome.buildProductGrid(selectedCategory)), // Show products based on category
          ],
        ),
      ),
    );
  }
Drawer buildDrawer() {
  return Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('useregistration') // Correct collection name
                  .doc(FirebaseAuth.instance.currentUser?.uid) // Use current user's ID
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
                String userImage = data['image'] ?? ''; // Fetch the image URL

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200], // Placeholder color
                      backgroundImage: userImage.isNotEmpty
                          ? NetworkImage(userImage) // Display image from Firestore
                          : const AssetImage("asset/profile.jpg") as ImageProvider, // Fallback image
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
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
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
                _showLogoutBottomSheet();
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

void _showLogoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await _auth.signOut();
                      preferences.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        (route) => false,
                      );
                      print('Logout confirmed');
                    },
                    child: const Text('Logout'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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