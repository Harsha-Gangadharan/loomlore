import 'package:flutter/material.dart';
import 'package:flutterlore/view/home/chatpage.dart';

import 'package:google_fonts/google_fonts.dart';

class WidgetHome {
  AppBar buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
      children: [
        Text(
          "Loom Lore",
          style: GoogleFonts.berkshireSwash(
              color: Color(0xff410502), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.telegram, color: Colors.black),
          onPressed: () {
          
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()), 
            );
          },
        ),
        SizedBox(
          width: 10,
        ),
        CircleAvatar(backgroundImage: AssetImage("asset/profile.jpg")),
      ],
    ),
  );
}


  Widget buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hello, Welcome 👋", style: GoogleFonts.poppins(fontSize: 20)),
        Text("Harsha",
            style:GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search Styles...",
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.tune,
        color: Color(0xffCC8381),),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget buildCategoryTabs() {
    final categories = ["All Items", "Women", "Men", "Colourwheel"];
    return SingleChildScrollView(
      scrollDirection:
          Axis.horizontal, 
      child: Row(
        children: categories
            .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildCategoryTab(category, category == "All Items"),
                ))
            .toList(),
      ),
    );
  }

  Widget buildCategoryTab(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xffCC8381): Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffCC8381)!),
      ),
      child: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget buildProductGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16),
      itemCount: 4,
      itemBuilder: (context, index) => buildProductCard(),
    );
  }

  Widget buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                "asset/three.jpeg",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Name",
                    style:
                       GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text("4.5"),
                    Spacer(),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20, 
                          backgroundImage: AssetImage(
                              'asset/person.jpeg'), 
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .blue,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16, 
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text("By John Azzi"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}