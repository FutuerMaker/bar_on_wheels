import 'package:bar_on_wheels/constants/routes.dart';
import 'package:bar_on_wheels/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:bar_on_wheels/screens/change_password/change_password.dart';
import 'package:bar_on_wheels/screens/edit_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Center(
          child: Text(
            "Acccount",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                appProvider.getUserInformation.image == null
                    ? const Icon(
                        Icons.person_outlined,
                        size: 150,
                      )
                    : Image.network(
                        appProvider.getUserInformation.image!,
                        // width: MediaQuery.of(context).size.width * 1.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                Text(
                  appProvider.getUserInformation.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  appProvider.getUserInformation.email,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Routes.instance.push(const EditProfile(), context);
                  },
                  leading: const Icon(Icons.person),
                  title: const Text("Edit Proflie"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.local_shipping_outlined),
                  title: const Text("Your Orders"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance.push(const ChangePassword(), context);
                  },
                  leading: const Icon(Icons.password),
                  title: const Text("Change Password"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About Us"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.contact_support_outlined),
                  title: const Text("Support"),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuthHelper.instance.signOut();
                    setState(() {});
                  },
                  leading: const Icon(Icons.exit_to_app_outlined),
                  title: const Text("Log out"),
                ),
                const Text("Version 1.0.0"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
