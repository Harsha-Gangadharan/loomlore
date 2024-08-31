import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/creation.dart';
import 'package:flutterlore/view/home/homewidget.dart';
import 'package:flutterlore/view/home/notificationpage.dart';
import 'package:flutterlore/view/home/wishlist.dart';




class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WidgetHome a = WidgetHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: a.buildAppBar(context), 
      drawer: buildDrawer(), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            a.buildGreeting(),
            a.buildSearchBar(),
            SizedBox(height: 20),
            a.buildCategoryTabs(),
            SizedBox(height: 20),
            Expanded(child: a.buildProductGrid()),
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer() {
  return Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("asset/profile.jpg"),
                ),
                SizedBox(height: 10),
                Text(
                  'Harsha',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'jane.doe@gmail.com',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
            onTap: () {
             
                   Navigator.push(context,MaterialPageRoute(builder: (context) =>NotificationPage(), 
));
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('My Creation'),
            onTap: () {
             
                   Navigator.push(context,MaterialPageRoute(builder: (context) =>MyCreationPage(), 
));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Wishlist'),
            onTap: () {
              
                   Navigator.push(context,MaterialPageRoute(builder: (context) =>WishlistPage(), 
));
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Complaints'),
            onTap: () {
             
            },
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffd9a0a0),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                
              },
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    ),
  );
}

  }