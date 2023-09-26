import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:926954108162:ios:1171712ac919f16e3c3e1b',
        apiKey: 'AIzaSyDsjQgP3O3u-tBwS7SheHPhprS8ui_m86k',
        projectId: 'bar-on-wheels-app',
        messagingSenderId: '926954108162',
        iosBundleId: 'com.example.barOnWheels',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:926954108162:android:1ca0e07a97df1ffa3c3e1b',
        apiKey: 'AIzaSyC4x2bdX6tT8zMPaaE5ozkOr1RiECteuEg',
        projectId: 'bar-on-wheels-app',
        messagingSenderId: 'com.example.barOnWheels',
      );
    }
  }
}
