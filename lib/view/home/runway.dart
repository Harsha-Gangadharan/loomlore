import 'package:flutter/material.dart';

import 'package:flutterlore/view/home/runwaywidget.dart';

class RunwayPage extends StatefulWidget {
  const RunwayPage({super.key});

  @override
  State<RunwayPage> createState() => _RunwayPageState();
}

class _RunwayPageState extends State<RunwayPage> {
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
        title: Image.asset(
          'asset/fashion.png',  
          height: 710,
          
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,  
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.6,  
          ),
          itemCount: 4,  
          itemBuilder: (context, index) {
            return FashionItem(
              imageUrl: 'asset/p1.jpeg', 
              username: ['Harsha', 'Vismaya', 'Thejas', 'Chethan'][index],  
              likes: ['41k', '40k', '39k', '38k'][index], 
              profilePic: 'asset/eric.jpeg', image: 'asset/fashion.png',
            );
          },
        ),
      ),
    );
  }
}