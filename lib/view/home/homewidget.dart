import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/chat/chatroom.dart';
import 'package:flutterlore/view/home/chat/message.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetHome {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
 
  String searchQuery = ''; // Variable to hold the search query
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
                MaterialPageRoute(builder: (context) => Chatscreen()),
              );
          },
        ),
        const SizedBox(width: 10),
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('useregistration') // Correct collection name
              .doc(FirebaseAuth.instance.currentUser?.uid) // Use current user's ID
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
                backgroundImage: AssetImage("asset/profile.jpg"), // Fallback image
              );
            }
            DocumentSnapshot data = snapshot.data!;
            String userImage = data['image'] ?? ''; // Fetch the image URL

            return CircleAvatar(
              backgroundColor: Colors.grey[200], // Placeholder color
              backgroundImage: userImage.isNotEmpty
                  ? NetworkImage(userImage) // Display image from Firestore
                  : const AssetImage("asset/profile.jpg") as ImageProvider, // Fallback image
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
  String designerUid = productData['uid'] ?? '';
  String productId = productData['id'] ?? ''; // Ensure there's an ID for each product

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
      String designerName = designerData['username'] ?? 'Unknown Designer';
      String designerImage = designerData['image'] ?? '';

      // Variable to track if the product is liked
      bool isLiked = false;

      return StatefulBuilder(
        builder: (context, setState) {
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
                      productData['productimage'] ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Image.asset('asset/default_product_image.png'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items evenly
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow, size: 16),
                              const Text("4.5"),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle rating button click
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffCC8381),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Rating", style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              await toggleWishlist(productData, designerData.data() as Map<String, dynamic>, productId);
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: designerImage.isNotEmpty
                                    ? NetworkImage(designerImage)
                                    : const AssetImage('asset/person.jpeg') as ImageProvider,
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
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text("By $designerName"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
  return MessageScreen(
    receiverID: designerUid,
    receiverEmail: designerData['email'],
    receiverCollection: 'designeregistration',  // Specify the designer's collection
  );
}));

                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}



Future<void> toggleWishlist(Map<String, dynamic> productData, Map<String, dynamic> designerData, String productId) async {
  String? currentUid = currentUser?.uid;
  if (currentUid == null) return;

  DocumentReference wishlistRef = firestore.collection('wishlist').doc(currentUid);

  DocumentSnapshot wishlistSnapshot = await wishlistRef.get();
  
  if (wishlistSnapshot.exists) {
    // The document exists, so we can safely access the fields
    List<dynamic> wishlistItems = wishlistSnapshot.get('items') ?? [];
    List<dynamic> products = wishlistSnapshot.get('products') ?? [];

    if (wishlistItems.contains(productId)) {
      // Remove the product from the wishlist
      wishlistItems.remove(productId);
      products.removeWhere((product) => product['productId'] == productId);
    } else {
      // Add the product to the wishlist
      wishlistItems.add(productId);
      products.add({
        'productId': productId,
        'productimage': productData['productimage'],
        'description': productData['description'],
        'designerName': designerData['username'],
        'designerImage': designerData['image'],
      });
    }

    await wishlistRef.update({
      'items': wishlistItems,
      'products': products,
    });
  } else {
    // The document doesn't exist, so we create it with the initial data
    await wishlistRef.set({
      'items': [productId],
      'products': [
        {
          'productId': productId,
          'productimage': productData['productimage'],
          'description': productData['description'],
          'designerName': designerData['username'],
          'designerImage': designerData['image'],
        }
      ],
    });
  }
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
