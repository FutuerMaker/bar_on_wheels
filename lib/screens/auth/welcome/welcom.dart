import 'package:bar_on_wheels/constants/routes.dart';
import 'package:bar_on_wheels/screens/auth/login/login.dart';
import 'package:bar_on_wheels/screens/auth/signup/sign_up.dart';
import 'package:bar_on_wheels/widgets/titles/top_title.dart';
import 'package:flutter/material.dart';

import '../../../constants/assets_images.dart';
import '../../../widgets/btns/primary_btn.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopTitle(
                title: "Welcome to Bar On Wheels",
                subtitle: "Discover your taste"),
            Center(
              child: Image.asset(
                AssetImages.instance.welcomImg,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       icon: const Icon(
            //         Icons.facebook,
            //         size: 35,
            //       ),
            //       color: Colors.blue,
            //       onPressed: () {},
            //     ),
            //     IconButton(
            //       icon: const Icon(
            //         Icons.g_mobiledata,
            //         size: 35,
            //       ),
            //       color: Colors.blue,
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12,
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    title: "Login",
                    onPress: () {
                      Routes.instance.push(const Login(), context);
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  PrimaryButton(
                    title: "Sign up",
                    onPress: () {
                      Routes.instance.push(const SignUp(), context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
