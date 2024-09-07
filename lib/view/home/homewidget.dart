import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetHome {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Text(
            "Loom Lore",
            style: GoogleFonts.berkshireSwash(
              color: const Color(0xff410502),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.telegram, color: Colors.black),
            onPressed: () {
              // Define ChatPage or navigate to it
            },
          ),
          SizedBox(width: 10),
          CircleAvatar(backgroundImage: AssetImage("asset/profile.jpg")),
        ],
      ),
    );
  }

  Widget buildGreeting() {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore
          .collection('useregistration')
          .doc(currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Text('No data available'));
        }
        DocumentSnapshot data = snapshot.data!;
        if (!data.exists) {
          return Center(child: Text('User not found'));
        }

        String userName = data['username'] ?? 'No Name';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, Welcome 👋", style: GoogleFonts.poppins(fontSize: 20)),
            Text(userName,
                style: GoogleFonts.poppins(
                    fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search Styles...",
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.tune, color: Color(0xffCC8381)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget buildCategoryTabs(Function(String) onCategorySelected, String selectedCategory) {
    final categories = ["All Items", "Women", "Men", "Colourwheel"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              onCategorySelected(category); // Trigger the selection
            },
            child: buildCategoryTab(category, category == selectedCategory),
          );
        }).toList(),
      ),
    );
  }

  Widget buildCategoryTab(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xffCC8381) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffCC8381)),
      ),
      child: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget buildProductGrid(String selectedCategory) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getAllPosts(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No Posts"));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var productData = products[index].data();
            return buildProductCard(productData);
          },
        );
      },
    );
  }

  Widget buildProductCard(Map<String, dynamic> productData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                productData["productimage"],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData['description'] ?? 'No description available',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const Text("4.5"),
                    Spacer(),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('asset/person.jpeg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text("By John Azzi"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts(String selectedCategory) {
    if (selectedCategory == "All Items") {
      return firestore.collection("productdetails").snapshots();
    } else {
      return firestore
          .collection("productdetails")
          .where('category', isEqualTo: selectedCategory)
          .snapshots();
    }
  }
}
