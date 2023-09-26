import 'package:bar_on_wheels/constants/constants.dart';
import 'package:bar_on_wheels/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:flutter/material.dart';

import '../../widgets/btns/primary_btn.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isShowPassword = true;
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 36),
        children: [
          TextFormField(
            obscureText: isShowPassword,
            controller: newPassword,
            decoration: InputDecoration(
              hintText: "New Password",
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                icon: isShowPassword
                    ? const Icon(
                        Icons.visibility_off_outlined,
                      )
                    : const Icon(Icons.visibility_outlined),
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            obscureText: isShowPassword,
            controller: confirmNewPassword,
            decoration: InputDecoration(
              hintText: "Confirm New Password",
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                icon: isShowPassword
                    ? const Icon(
                        Icons.visibility_off_outlined,
                      )
                    : const Icon(Icons.visibility_outlined),
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 72,
          ),
          PrimaryButton(
            title: "Set Password",
            onPress: () async {
              if (newPassword.text.isEmpty || newPassword.text.length < 6) {
                showMessage("Password can't less than 6 letters");
              }
              if (confirmNewPassword.text == newPassword.text) {
                FirebaseAuthHelper.instance
                    .changePassword(newPassword.text, context);
                showMessage("Password changed");
              } else {
                showMessage("Your passwords dont match");
              }
            },
          ),
        ],
      ),
    );
  }
}
