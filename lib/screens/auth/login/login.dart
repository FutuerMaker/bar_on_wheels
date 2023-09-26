import 'package:bar_on_wheels/constants/constants.dart';
import 'package:bar_on_wheels/widgets/nav_bar/nav_bar.dart';
import 'package:bar_on_wheels/widgets/titles/top_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import '../../../widgets/btns/primary_btn.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassword = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitle(
                title: "Login",
                subtitle: "Welcome back!!",
              ),
              const SizedBox(
                height: 46,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                obscureText: isShowPassword,
                controller: password,
                decoration: InputDecoration(
                  hintText: "Password",
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
                height: 36,
              ),
              PrimaryButton(
                title: "Login",
                onPress: () async {
                  bool isVaildate = loginVaildation(
                    email.text,
                    password.text,
                  );
                  if (isVaildate) {
                    bool isLogined = await FirebaseAuthHelper.instance.login(
                      email.text,
                      password.text,
                      context,
                    );
                    if (isLogined) {
                      // ignore: use_build_context_synchronously
                      Routes.instance.pushAndRemoveUntil(
                        widget: const CustomNavigationBar(),
                        context: context,
                      );
                    }
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const Center(
                child: Text("Have an account?"),
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Routes.instance.push(const Login(), context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
