// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNibvxIz6B7MyA-jizQ_Q5VVG67cSAc9M',
    appId: '1:588569148924:android:306b15a0878164afac0679',
    messagingSenderId: '588569148924',
    projectId: 'norm-request',
    storageBucket: 'norm-request.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGE8ywcPePWNZmC_aNbm-sLaUk6WYxTTw',
    appId: '1:588569148924:ios:bf2710b193b39251ac0679',
    messagingSenderId: '588569148924',
    projectId: 'norm-request',
    storageBucket: 'norm-request.appspot.com',
    iosClientId: '588569148924-711fhprnfgcpt7mi3a7bts0a9h3ovfo4.apps.googleusercontent.com',
    iosBundleId: 'com.yuu.norm.request.normRequest',
  );
}