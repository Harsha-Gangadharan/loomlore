import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class Packages extends StatefulWidget {
  int indexNum;
  Packages({Key? key, required this.indexNum}) : super(key: key);

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages> with TickerProviderStateMixin {
  late final List<Widget> _pages;
  late final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey;

  int _currentIndex = 0;
  late final AnimationController revealAnimationController;

  @override
  void initState() {
    super.initState();
    _pages = [
    //   HomePage(),
    //   DesignPage(),
    //   RunwayPage(),
    // LocationPage(),
      // Add other pages here
    ];

    _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();
    revealAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      widget.indexNum = index;
      _currentIndex = index;
    });
    revealAnimationController.reset();
    revealAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.style, size: 30),
          Icon(Icons.video_camera_back, size: 30),
          Icon(Icons.location_on, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color(0xffCC8381),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: onTabTapped,
      ),
    );
  }

  @override
  void dispose() {
    revealAnimationController.dispose();
    super.dispose();
  }
}