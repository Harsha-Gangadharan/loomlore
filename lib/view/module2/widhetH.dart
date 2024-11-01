import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/chat/chatroom.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWidgPage {
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
           const Spacer(),
        IconButton(
          icon: const Icon(Icons.telegram, color: Colors.black),
          onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatRoomScreen()),
              );
          },
        ),
          const SizedBox(width: 10),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('designeregistration')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.hasError) {
                return const CircleAvatar(
                  backgroundImage: AssetImage("asset/profile.jpg"),
                );
              }
              DocumentSnapshot data = snapshot.data!;
              String userImage = data['image'] ?? '';

              return CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage: userImage.isNotEmpty
                    ? NetworkImage(userImage)
                    : const AssetImage("asset/profile.jpg") as ImageProvider,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildGreeting() {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestore
          .collection('designeregistration')
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

 Widget buildSearchBar(BuildContext context, Function(String) onCategorySelected) {
  return TextField(
    decoration: InputDecoration(
      hintText: "Search Styles...",
      prefixIcon: Icon(Icons.search),
      suffixIcon: IconButton(
        icon: Icon(Icons.tune, color: Color(0xffCC8381)),
        onPressed: () {
          // Show a dialog or bottom sheet with category options
          showCategorySelectionDialog(context, onCategorySelected);
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[200],
    ),
  );
}

void showCategorySelectionDialog(BuildContext context, Function(String) onCategorySelected) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      final categories = ['Officewear', 'Party Wear', 'Casual Wear', 'Western', 'Traditional'];
      
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit the content size
          children: categories.map((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                onCategorySelected(category); // Pass selected category back
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          }).toList(),
        ),
      );
    },
  );
}


  Widget buildCategoryTabs(Function(String) onCategorySelected, String selectedCategory) {
    final categories = ["All Items"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              onCategorySelected(category);
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
  String designerUid = productData['uid'] ?? ''; // Ensure designerUid exists
  String productId = productData['id'] ?? ''; // Ensure productId exists

  return FutureBuilder<DocumentSnapshot>(
    future: firestore.collection('designeregistration').doc(designerUid).get(),
    builder: (context, designerSnapshot) {
      if (designerSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (designerSnapshot.hasError || !designerSnapshot.hasData || !designerSnapshot.data!.exists) {
        return Center(child: Text('Designer info unavailable'));
      }

      var designerData = designerSnapshot.data!;
      
      // Provide default values if data is null
      String designerName = designerData['username'] ?? 'Unknown Designer';
      String designerImage = designerData['image'] ?? '';  // Use a default asset if needed
      
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  productData['productimage'] ?? '',  // Check for null here
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.broken_image, size: 100),  // Fallback if image fails to load
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productData['description'] ?? 'No description available',  // Check for null
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    Row(
                      children: [
                        // const Icon(Icons.star, color: Colors.yellow, size: 16),
                        // const Text("4.5"),
                        const Spacer(),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: designerImage.isNotEmpty
                                  ? NetworkImage(designerImage)
                                  : const AssetImage('asset/person.jpeg')
                                      as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: const Icon(
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
                    Text("By $designerName"),
                    // Row(
                    //   children: [
                    //     FutureBuilder<bool>(
                    //       future: checkLikeStatus(productId),
                    //       builder: (context, likeSnapshot) {
                    //         if (!likeSnapshot.hasData) {
                    //           return Icon(Icons.favorite_border, color: Colors.grey);
                    //         }
                    //         bool isLiked = likeSnapshot.data!;
                    //         // return IconButton(
                    //         //   icon: Icon(
                    //         //     isLiked ? Icons.favorite : Icons.favorite_border,
                    //         //     color: isLiked ? Colors.red : Colors.grey,
                    //         //   ),
                    //         //   onPressed: () async {
                    //         //     toggleLikeStatus(productId);
                    //         //   },
                    //         // );
                    //       },
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Text('Like'),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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

  Future<void> toggleLikeStatus(String productId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistRef = firestore.collection('wishlist').doc(userId);
    final wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.exists) {
      List<dynamic> likedProducts = wishlistSnapshot.data()!['likedProducts'] ?? [];

      if (likedProducts.contains(productId)) {
        await wishlistRef.update({
          'likedProducts': FieldValue.arrayRemove([productId]),
        });
      } else {
        await wishlistRef.update({
          'likedProducts': FieldValue.arrayUnion([productId]),
        });
      }
    } else {
      await wishlistRef.set({
        'likedProducts': [productId],
      });
    }
  }

  Future<bool> checkLikeStatus(String productId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistRef = firestore.collection('wishlist').doc(userId);
    final wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.exists) {
      List<dynamic> likedProducts = wishlistSnapshot.data()!['likedProducts'] ?? [];
      return likedProducts.contains(productId);
    }

    return false;
  }
}
