import 'package:bar_on_wheels/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:bar_on_wheels/firebase_helper/firebase_options/firebase_options.dart';
import 'package:bar_on_wheels/providers/app_provider.dart';
import 'package:bar_on_wheels/screens/auth/welcome/welcom.dart';
import 'package:bar_on_wheels/widgets/nav_bar/nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NsRk2BOiYiTDmaxkNi76lnMIitaG1gPMEOH3bn3G3lpEcB3p7dxZ9g4I2fMdgQzO9QMkviafkf9Od9Fd6zCMdIw00nJBf1aAd";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bar On Wheels',
          theme: themeData,
          home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const CustomNavigationBar();
              } else {
                return const Welcome();
              }
            },
          )),
    );
  }
}
