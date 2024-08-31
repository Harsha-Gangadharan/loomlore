// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB6V43eC7b6BLszkL1yYcEPi2kAZanlwKg',
    appId: '1:347695721501:web:3596e4495bb95950e56af4',
    messagingSenderId: '347695721501',
    projectId: 'lore-cf0ee',
    authDomain: 'lore-cf0ee.firebaseapp.com',
    storageBucket: 'lore-cf0ee.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYA2rw5ff9KFh-OXH7NgW_wf401eMXo2c',
    appId: '1:347695721501:android:cb6bd6a793ccb624e56af4',
    messagingSenderId: '347695721501',
    projectId: 'lore-cf0ee',
    storageBucket: 'lore-cf0ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjl4wCOPEkl5ld5hxVBR0rsfLwsOK7q_8',
    appId: '1:347695721501:ios:3be1c25b74e03cb7e56af4',
    messagingSenderId: '347695721501',
    projectId: 'lore-cf0ee',
    storageBucket: 'lore-cf0ee.appspot.com',
    iosBundleId: 'com.example.flutterlore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjl4wCOPEkl5ld5hxVBR0rsfLwsOK7q_8',
    appId: '1:347695721501:ios:3be1c25b74e03cb7e56af4',
    messagingSenderId: '347695721501',
    projectId: 'lore-cf0ee',
    storageBucket: 'lore-cf0ee.appspot.com',
    iosBundleId: 'com.example.flutterlore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB6V43eC7b6BLszkL1yYcEPi2kAZanlwKg',
    appId: '1:347695721501:web:426ca8095d84ffcbe56af4',
    messagingSenderId: '347695721501',
    projectId: 'lore-cf0ee',
    authDomain: 'lore-cf0ee.firebaseapp.com',
    storageBucket: 'lore-cf0ee.appspot.com',
  );
}