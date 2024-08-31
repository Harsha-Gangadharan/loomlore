import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/methods.dart';


class MyCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'My Creation',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  buildDressItem(
                    imageUrl: AssetImage("asset/one.jpeg"), 
                    isPublic: true,
                    likes: '4k',
                  ),
                  buildDressItem(
                    imageUrl: AssetImage("asset/two.jpeg"), 
                    isPublic: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}