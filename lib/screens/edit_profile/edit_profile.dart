import 'dart:io';

// import 'package:bar_on_wheels/constants/constants.dart';
// import 'package:bar_on_wheels/firebase_helper/firebase_storage_helper/firebase_storage.dart';
import 'package:bar_on_wheels/models/user_model/user_model.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/app_provider.dart';
import '../../widgets/btns/primary_btn.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Your Info",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        children: [
          image == null
              ? IconButton(
                  onPressed: () {
                    takePicture();
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    takePicture();
                  },
                  child: Image.file(
                    image!,
                    // width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
          const SizedBox(
            height: 24,
          ),
          TextFormField(
            controller: textEditingController,
            decoration:
                InputDecoration(hintText: appProvider.getUserInformation.name),
          ),
          const SizedBox(
            height: 12,
          ),
          PrimaryButton(
            title: "Update Information",
            onPress: () async {
              UserModel userModel = appProvider.getUserInformation
                  .copyWith(name: textEditingController.text);
              appProvider.updateUserInfoFirebase(context, userModel, image);
            },
          ),
        ],
      ),
    );
  }
}
