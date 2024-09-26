import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('wishlist').doc(currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text('No wishlist available'));
          }

          DocumentSnapshot data = snapshot.data!;
          List<dynamic> products = data['products'] ?? [];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product['productimage'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(product['description']),
                subtitle: Text("By ${product['designerName']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(product['designerImage']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteProductFromWishlist(product);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteProductFromWishlist(Map<String, dynamic> product) async {
    String? currentUid = currentUser?.uid;
    if (currentUid == null) return;

    DocumentReference wishlistRef = firestore.collection('wishlist').doc(currentUid);
    DocumentSnapshot wishlistSnapshot = await wishlistRef.get();

    if (wishlistSnapshot.exists) {
      List<dynamic> products = wishlistSnapshot.get('products') ?? [];

      // Remove the product from the list
      products.removeWhere((p) => p['productimage'] == product['productimage']);

      // Update Firestore
      await wishlistRef.update({'products': products});
    }
  }
}
