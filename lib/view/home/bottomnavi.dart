import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/chat/chatroom.dart';
import 'package:flutterlore/view/home/home.dart';
import 'package:flutterlore/view/home/location.dart';
import 'package:flutterlore/view/home/runway.dart';
import 'package:flutterlore/view/home/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Packages extends StatefulWidget {
  final int indexNum; // This will be passed as a parameter to set the initial page
  Packages({Key? key, required this.indexNum}) : super(key: key);

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> with TickerProviderStateMixin {
  late final List<Widget> _pages;
  late final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey;

  late final AnimationController revealAnimationController;
  int _currentIndex = 0; // This will track the currently selected index

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      DesignPage(),
      const RunwayPage(),
      LocationPage(),
      Chatscreen(),
    ];

    // Initialize the _currentIndex with the passed indexNum
    _currentIndex = widget.indexNum;

    _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();
    revealAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Set the current index to the selected tab
    });
    revealAnimationController.reset();
    revealAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex], // Display the page corresponding to the selected index
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex, // Make sure this uses _currentIndex
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.style, size: 30),
          Icon(Icons.video_camera_back, size: 30),
          Icon(Icons.location_on, size: 30),
          Icon(Icons.chat, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color(0xffCC8381),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: onTabTapped, // Use the onTabTapped function to handle navigation
      ),
    );
  }

  @override
  void dispose() {
    revealAnimationController.dispose();
    super.dispose();
  }
}

class MyNav extends StatefulWidget {
  final int index;
  final void Function(int)? onTap;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const MyNav({
    Key? key,
    required this.index,
    required this.onTap,
    required this.firestore,
    required this.auth,
  }) : super(key: key);

  @override
  _MyNavState createState() => _MyNavState();
}

class _MyNavState extends State<MyNav> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  @override
  void didUpdateWidget(covariant MyNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.auth.currentUser != widget.auth.currentUser) {
      _fetchProfileImage();
    }
  }

  Future<void> _fetchProfileImage() async {
    String id = widget.auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await widget.firestore.collection('designeregistration').doc(id).get();
    setState(() {
      _imageUrl = userSnapshot.data()?['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _imageUrl == null
            ? CircularProgressIndicator()
            : Image.network(_imageUrl!),
      ),
    );
  }
}
