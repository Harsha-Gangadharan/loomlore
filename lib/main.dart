import 'package:flutter/material.dart';
import 'package:flutterlore/firebase_options.dart';
import 'package:flutterlore/newsample.dart';
import 'package:flutterlore/sample.dart';
import 'package:flutterlore/view/authentication/sign.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutterlore/view/prosample.dart';
import 'package:flutterlore/view/welcome.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
// ...
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
 runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( context) => A(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue
        ),
        home:  
        //  samplePage(),
      //  
      Welcome()
      
      ),
    );
  }
}