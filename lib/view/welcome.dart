import 'package:flutter/material.dart';
import 'package:flutterlore/view/authentication/sign.dart';
import 'package:flutterlore/view/module2/packege.dart';
import 'package:flutterlore/view/module2/signn.dart';
import 'package:google_fonts/google_fonts.dart';


class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffCC8381),
         title: const Text('WELCOME'),
        titleTextStyle: GoogleFonts.inknutAntiqua(
          fontSize: 26,
          color: const Color.fromARGB(255, 14, 14, 14),
        ),
      ),
      body: Stack(
        children: [Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/w1.png"), // Replace with your image path
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Change the opacity value here (0.5 for 50% opacity)
              BlendMode.dstATop, // Adjust the blend mode as needed
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        
      ),
      SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 300,),
            child: Center( // Wrap the Column with Center
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                    width: double.infinity, // Make the button take the full width
                    child: Center(
                      child: ElevatedButton(
                        
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DesignerRegistrationPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:    Color(0xffCC8381),
                          fixedSize: Size(250, 50)
                        ),
                        child: Text(
                          'Are You An Designer',
                          style: GoogleFonts.inknutAntiqua(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add some space between the buttons
                  SizedBox(
                    height: 50.0,
                    width: double.infinity, // Make the button take the full width
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color(0xffCC8381),
                          fixedSize: Size(250, 50)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'User Sign',
                            style: GoogleFonts.inknutAntiqua(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ]
    ),
    );
  }
}
