import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyD8mfbm2s6dfBy8hB53WHbw6vJiOBm56WM',
    appId: '1:819990231025:web:c4cf77f73a7cfc861ab650',
    messagingSenderId: '819990231025',
    projectId: 'mixandslay',
    authDomain: 'mixandslay.firebaseapp.com',
    storageBucket: 'mixandslay.firebasestorage.app',
    measurementId: 'G-PFYPSRRGCF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaepYYK0nK1rFKeuxYTP7BZgm5rFihWFw',
    appId: '1:819990231025:android:829ca68e684189831ab650',
    messagingSenderId: '819990231025',
    projectId: 'mixandslay',
    storageBucket: 'mixandslay.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATWkwjnOEVbmDANLnt18GouEVZtAU53us',
    appId: '1:819990231025:ios:fdd17337fab18fd31ab650',
    messagingSenderId: '819990231025',
    projectId: 'mixandslay',
    storageBucket: 'mixandslay.firebasestorage.app',
    iosBundleId: 'com.example.mixnslay',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyATWkwjnOEVbmDANLnt18GouEVZtAU53us',
    appId: '1:819990231025:ios:fdd17337fab18fd31ab650',
    messagingSenderId: '819990231025',
    projectId: 'mixandslay',
    storageBucket: 'mixandslay.firebasestorage.app',
    iosBundleId: 'com.example.mixnslay',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD8mfbm2s6dfBy8hB53WHbw6vJiOBm56WM',
    appId: '1:819990231025:web:bd2f6c63150030051ab650',
    messagingSenderId: '819990231025',
    projectId: 'mixandslay',
    authDomain: 'mixandslay.firebaseapp.com',
    storageBucket: 'mixandslay.firebasestorage.app',
    measurementId: 'G-ZE2NKQ2PFW',
  );
}