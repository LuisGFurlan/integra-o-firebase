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
    apiKey: 'AIzaSyDHEzfNNBEV0e2pxs9KA43sP1969SoaK4s',
    appId: '1:866346447616:web:22cf85c01852b46ec239e5',
    messagingSenderId: '866346447616',
    projectId: 'flutter-valida',
    authDomain: 'flutter-valida.firebaseapp.com',
    storageBucket: 'flutter-valida.firebasestorage.app',
    measurementId: 'G-G62E136SV4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3FhYD-2J4rwB6lQBEbxvKvTgYriqSLKo',
    appId: '1:866346447616:android:ce7d0de412cdbe75c239e5',
    messagingSenderId: '866346447616',
    projectId: 'flutter-valida',
    storageBucket: 'flutter-valida.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeouZrq7tVf8W15BF3rTRfjfJuO_b4KQo',
    appId: '1:866346447616:ios:83f0e7c6c2ff445dc239e5',
    messagingSenderId: '866346447616',
    projectId: 'flutter-valida',
    storageBucket: 'flutter-valida.firebasestorage.app',
    iosBundleId: 'com.example.firebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeouZrq7tVf8W15BF3rTRfjfJuO_b4KQo',
    appId: '1:866346447616:ios:83f0e7c6c2ff445dc239e5',
    messagingSenderId: '866346447616',
    projectId: 'flutter-valida',
    storageBucket: 'flutter-valida.firebasestorage.app',
    iosBundleId: 'com.example.firebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDHEzfNNBEV0e2pxs9KA43sP1969SoaK4s',
    appId: '1:866346447616:web:9d2dabc3257c2124c239e5',
    messagingSenderId: '866346447616',
    projectId: 'flutter-valida',
    authDomain: 'flutter-valida.firebaseapp.com',
    storageBucket: 'flutter-valida.firebasestorage.app',
    measurementId: 'G-G6H7NS2M9P',
  );

}