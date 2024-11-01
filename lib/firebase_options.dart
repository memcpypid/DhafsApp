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
    apiKey: 'AIzaSyB2kW8ECfS0Rgi-Mv4H7LHZxkMT1Gz10mQ',
    appId: '1:819189167986:web:d50aca18563e36d4380feb',
    messagingSenderId: '819189167986',
    projectId: 'dhafs-app',
    authDomain: 'dhafs-app.firebaseapp.com',
    storageBucket: 'dhafs-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbUpQuo3KC52hgJZl3FV59YBzRQqkFHqI',
    appId: '1:819189167986:android:0809b89c23284c18380feb',
    messagingSenderId: '819189167986',
    projectId: 'dhafs-app',
    storageBucket: 'dhafs-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTNRpPas0hP9w2amLB02dehWNIktqiYaU',
    appId: '1:819189167986:ios:4a07df362d4ffa71380feb',
    messagingSenderId: '819189167986',
    projectId: 'dhafs-app',
    storageBucket: 'dhafs-app.appspot.com',
    iosBundleId: 'umm.dhafsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTNRpPas0hP9w2amLB02dehWNIktqiYaU',
    appId: '1:819189167986:ios:4a07df362d4ffa71380feb',
    messagingSenderId: '819189167986',
    projectId: 'dhafs-app',
    storageBucket: 'dhafs-app.appspot.com',
    iosBundleId: 'umm.dhafsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2kW8ECfS0Rgi-Mv4H7LHZxkMT1Gz10mQ',
    appId: '1:819189167986:web:f23813e07c49df21380feb',
    messagingSenderId: '819189167986',
    projectId: 'dhafs-app',
    authDomain: 'dhafs-app.firebaseapp.com',
    storageBucket: 'dhafs-app.appspot.com',
  );
}
