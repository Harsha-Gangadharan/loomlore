import 'package:flutter/material.dart';
import 'package:flutterlore/firebase_options.dart';
import 'package:flutterlore/view/authentication/sign.dart';
import 'package:firebase_core/firebase_core.dart';



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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: SignUp(),
    );
  }
}