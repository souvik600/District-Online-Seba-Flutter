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
    apiKey: 'AIzaSyAAZ0eNPsHHhQxf9162O-higNxuHqUkSU0',
    appId: '1:974173007735:web:3587b1b7c1d06bb57dbb72',
    messagingSenderId: '974173007735',
    projectId: 'admin-narail',
    authDomain: 'admin-narail.firebaseapp.com',
    databaseURL: 'https://admin-narail-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'admin-narail.appspot.com',
    measurementId: 'G-15Q5FCJDBC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCC6U3BzTAJ69CQJu_a8dGNjVPIywbAhxw',
    appId: '1:974173007735:android:69acca8466cbdaf17dbb72',
    messagingSenderId: '974173007735',
    projectId: 'admin-narail',
    databaseURL: 'https://admin-narail-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'admin-narail.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3i-DYwOGSt2NW3ZuyNm5yfgr2HIz6vhs',
    appId: '1:974173007735:ios:426925e25f5af1727dbb72',
    messagingSenderId: '974173007735',
    projectId: 'admin-narail',
    databaseURL: 'https://admin-narail-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'admin-narail.appspot.com',
    iosClientId: '974173007735-uoii7hufovpqui4c0btqnfon8p6s4eif.apps.googleusercontent.com',
    iosBundleId: 'com.example.amaderNarail',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3i-DYwOGSt2NW3ZuyNm5yfgr2HIz6vhs',
    appId: '1:974173007735:ios:426925e25f5af1727dbb72',
    messagingSenderId: '974173007735',
    projectId: 'admin-narail',
    databaseURL: 'https://admin-narail-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'admin-narail.appspot.com',
    iosClientId: '974173007735-uoii7hufovpqui4c0btqnfon8p6s4eif.apps.googleusercontent.com',
    iosBundleId: 'com.example.amaderNarail',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAAZ0eNPsHHhQxf9162O-higNxuHqUkSU0',
    appId: '1:974173007735:web:6fb1bfdd17d7fe0e7dbb72',
    messagingSenderId: '974173007735',
    projectId: 'admin-narail',
    authDomain: 'admin-narail.firebaseapp.com',
    databaseURL: 'https://admin-narail-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'admin-narail.appspot.com',
    measurementId: 'G-SNDJ9HSPED',
  );
}