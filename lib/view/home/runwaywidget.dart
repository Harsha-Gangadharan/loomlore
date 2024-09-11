import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FashionItem extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String profilePic;
  final String image;
  final String description;
  final String productId; // Unique post identifier

  const FashionItem({
    required this.imageUrl,
    required this.username,
    required this.description,
    required this.profilePic,
    required this.image,
    required this.productId,
  });

  @override
  _FashionItemState createState() => _FashionItemState();
}

class _FashionItemState extends State<FashionItem> {
  bool isLiked = false;
  int totalLikes = 0;

  @override
  void initState() {
    super.initState();
    _fetchLikes();
  }

  // Fetch likes data from Firestore
  Future<void> _fetchLikes() async {
    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection('userstyles')
          .doc(widget.productId)
          .get();

      if (postDoc.exists) {
        // Ensure "Likes" is stored as an array
        List<dynamic> likes = postDoc['Likes'] ?? [];
        setState(() {
          totalLikes = likes.length;
        });
      } else {
        setState(() {
          totalLikes = 0; // No likes if document does not exist
        });
      }
    } catch (error) {
      print('Error fetching likes: $error');
    }
  }

  // Toggle like
  Future<void> _toggleLike() async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('userstyles').doc(widget.productId);

    try {
      DocumentSnapshot postDoc = await postRef.get();

      if (postDoc.exists) {
        List<dynamic> likes = List<dynamic>.from(postDoc['Likes'] ?? []);

        if (isLiked) {
          // Unlike: Remove an entry from the array (since we're not using user IDs)
          if (likes.isNotEmpty) {
            likes.removeLast();
          }
        } else {
          // Like: Add a placeholder entry to represent a like
          likes.add('like'); // This can be anything, we just need a placeholder
        }

        // Update the likes array in Firestore
        await postRef.update({'Likes': likes});

        setState(() {
          isLiked = !isLiked;
          totalLikes = likes.length; // Update the total likes count
        });
      } else {
        // If the post does not exist, create a new document with one like
        await postRef.set({
          'Likes': ['like'],
        });

        setState(() {
          isLiked = true;
          totalLikes = 1;
        });
      }
    } catch (error) {
      print('Error toggling like: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Profile picture
            Text(
              widget.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8),
            // Username
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePic),
              radius: 20,
            ),
          ],
        ),
        SizedBox(height: 8),
        // Fashion image
        Image.network(widget.imageUrl, fit: BoxFit.cover, height: 150),
        SizedBox(height: 8),
        // Description below the image
        Text(widget.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        SizedBox(height: 8),
        // Like button and total likes
        Row(
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: isLiked ? Colors.black : Colors.grey,
              ),
              onPressed: _toggleLike,
            ),
            Text('$totalLikes likes'),
          ],
        ),
      ],
    );
  }
}
