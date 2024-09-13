import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutterlore/view/home/home.dart';
import 'package:flutterlore/view/home/location.dart';
import 'package:flutterlore/view/home/runway.dart';
import 'package:flutterlore/view/home/style.dart';
import 'package:flutterlore/view/module2/adddesign.dart';
import 'package:flutterlore/view/module2/deignerhom.dart';



class DesignerPackages extends StatefulWidget {
  int indexno;
  DesignerPackages({Key? key, required this.indexno}) : super(key: key);

  @override
  State<DesignerPackages> createState() => _DesignerPackagesState();
}

class _DesignerPackagesState extends State<DesignerPackages> with TickerProviderStateMixin {
  late final List<Widget> _pages;
  late final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey;

  int _currentIndex = 0;
  late final AnimationController revealAnimationController;

  @override
  void initState() {
    super.initState();
    _pages = [
    const DesignerHomePage(),
    AddDesignPage(),
   RunwayPage(), 
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
      widget.indexno = index;
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
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add_box, size: 30),
          Icon(Icons.video_camera_back, size: 30),
          
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color(0xffCC8381),
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