import 'package:bar_on_wheels/constants/constants.dart';
import 'package:bar_on_wheels/screens/auth/login/login.dart';
import 'package:bar_on_wheels/widgets/nav_bar/nav_bar.dart';
import 'package:bar_on_wheels/widgets/titles/top_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import '../../../widgets/btns/primary_btn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShowPassword = true;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
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
                title: "Create Account",
                subtitle: "Welcome !!",
              ),
              const SizedBox(
                height: 46,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: name,
                decoration: const InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(Icons.account_circle_outlined),
                ),
              ),
              const SizedBox(
                height: 12,
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
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
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
                title: "Sign Up",
                onPress: () async {
                  bool isVaildate = signUpVaildation(
                    email.text,
                    password.text,
                    name.text,
                    phone.text,
                  );
                  if (isVaildate) {
                    bool isLogined = await FirebaseAuthHelper.instance.signUp(
                      name.text,
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
