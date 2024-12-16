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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD4Pj1_NB93WeaZFjx4fQ1SQ8zb6paMZqo',
    appId: '1:1097931406328:web:c5e09cd239d0471bcaf40d',
    messagingSenderId: '1097931406328',
    projectId: 'walletar-lite',
    authDomain: 'walletar-lite.firebaseapp.com',
    databaseURL: 'https://walletar-lite-default-rtdb.firebaseio.com',
    storageBucket: 'walletar-lite.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYCscKn0x3k6kHVglbNLMca-rbowVe6Us',
    appId: '1:1097931406328:android:e37933cdfd0a0928caf40d',
    messagingSenderId: '1097931406328',
    projectId: 'walletar-lite',
    databaseURL: 'https://walletar-lite-default-rtdb.firebaseio.com',
    storageBucket: 'walletar-lite.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD4Pj1_NB93WeaZFjx4fQ1SQ8zb6paMZqo',
    appId: '1:1097931406328:web:aca9d1851a0b597dcaf40d',
    messagingSenderId: '1097931406328',
    projectId: 'walletar-lite',
    authDomain: 'walletar-lite.firebaseapp.com',
    databaseURL: 'https://walletar-lite-default-rtdb.firebaseio.com',
    storageBucket: 'walletar-lite.firebasestorage.app',
  );
}