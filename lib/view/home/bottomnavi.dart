import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/home.dart';
import 'package:flutterlore/view/home/location.dart';
import 'package:flutterlore/view/home/runway.dart';
import 'package:flutterlore/view/home/style.dart';
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
