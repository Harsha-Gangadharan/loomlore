import 'package:flutter/material.dart';

class DesignPage extends StatefulWidget {
  const DesignPage({super.key});

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Define a GlobalKey for the Scaffold

  String selectedGender = 'Female';
  String selectedTop = '';
  String selectedBottom = '';
  Color selectedColor = Colors.white;
  String selectedDesign = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Stack(
          alignment: Alignment.centerRight,
          children: [
            Image.asset(
              'asset/create.png',
              height: 71,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 70, 42, 2),
                ),
                child: IconButton(
                  icon: Icon(Icons.tune, color: Color.fromARGB(255, 242, 241, 241)),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer(); // Open the drawer using the GlobalKey
                  },
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffCC8381),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gender selection
                  Text("Select Your Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Female',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                      Text("Female"),
                      Radio(
                        value: 'Male',
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                      Text("Male"),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Top selection
                  Text("Select The Top", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var top in ['Top1', 'Top2', 'Top3', 'Top4', 'Top5']) // Replace with actual images/icons
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTop = top;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedTop == top ?Color(0xffCC8381) : Colors.grey,
                              ),
                            ),
                            child: Icon(Icons.check_box_outline_blank), // Replace with your image/icon
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Bottom selection
                  Text("Select The Bottom", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var bottom in ['Bottom1', 'Bottom2', 'Bottom3', 'Bottom4']) // Replace with actual images/icons
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBottom = bottom;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedBottom == bottom ? Color(0xffCC8381) : Colors.grey,
                              ),
                            ),
                            child: Icon(Icons.check_box_outline_blank), // Replace with your image/icon
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Color selection
                  Text("Select The Colour", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var color in [
                        Colors.black,
                        Colors.white,
                        Colors.red,
                        Colors.green,
                        Colors.blue,
                        Colors.yellow,
                        // Add more colors here
                      ])
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: Border.all(
                                color: selectedColor == color ? Color(0xffCC8381) : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Design selection
                  Text("Select The Design", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var design in ['Design1', 'Design2', 'Design3', 'Design4']) // Replace with actual designs
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDesign = design;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedDesign == design ? Color(0xffCC8381) : Colors.grey,
                              ),
                            ),
                            child: Icon(Icons.check_box_outline_blank), // Replace with your image/design
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Your Design Name',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Image(image: AssetImage("asset/gown.jpg")),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Display'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Keep Private'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}