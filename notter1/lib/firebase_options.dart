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
    apiKey: 'AIzaSyBBNxvZiygrsvSsu97zpQNRhuE-85fip5s',
    appId: '1:1021260180387:web:11b3fd962a2511eaa3c816',
    messagingSenderId: '1021260180387',
    projectId: 'notter-2fc6f',
    authDomain: 'notter-2fc6f.firebaseapp.com',
    storageBucket: 'notter-2fc6f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2BW10WNnIF5d8PYmWP4-AoYobWD07g1w',
    appId: '1:1021260180387:android:ecde4bd658be5e3fa3c816',
    messagingSenderId: '1021260180387',
    projectId: 'notter-2fc6f',
    storageBucket: 'notter-2fc6f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzZTgliv8of3sdwZJdqsWg5RwyTpy_rBw',
    appId: '1:1021260180387:ios:533bcc42632f0c89a3c816',
    messagingSenderId: '1021260180387',
    projectId: 'notter-2fc6f',
    storageBucket: 'notter-2fc6f.firebasestorage.app',
    iosBundleId: 'com.example.notter1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzZTgliv8of3sdwZJdqsWg5RwyTpy_rBw',
    appId: '1:1021260180387:ios:533bcc42632f0c89a3c816',
    messagingSenderId: '1021260180387',
    projectId: 'notter-2fc6f',
    storageBucket: 'notter-2fc6f.firebasestorage.app',
    iosBundleId: 'com.example.notter1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBBNxvZiygrsvSsu97zpQNRhuE-85fip5s',
    appId: '1:1021260180387:web:56af78bbbe313c12a3c816',
    messagingSenderId: '1021260180387',
    projectId: 'notter-2fc6f',
    authDomain: 'notter-2fc6f.firebaseapp.com',
    storageBucket: 'notter-2fc6f.firebasestorage.app',
  );
}
