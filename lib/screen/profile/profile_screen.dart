import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/widget/avatar.dart';
import 'package:letsworkout/widget/bottomsheet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: AppBloc.userCubit.user?.name ?? "");

  dynamic _profileImage;
  bool _isProfileImageUpdate = false;

  @override
  void initState() {
    _profileImage = AppBloc.userCubit.user!.profileImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('프로필'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () async {
                bool success = await AppBloc.userCubit.updateUser(
                  name: _nameController.text,
                  isProfileImageUpdate: _isProfileImageUpdate,
                  image: _profileImage,
                );
                if (success) Navigator.pop(context);
              },
              child: const Center(child: Text('저장')),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 50),
            avatar(),
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 200,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _nameController,
                  maxLength: 6,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget avatar() {
    return InkWell(
      onTap: () async {
        await showFloatingModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  title: const Text('프로필 사진 지우기'),
                  onTap: () {
                    _profileImage = null;
                    _isProfileImageUpdate = true;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('사진첩에서 가져오기'),
                  onTap: () async {
                    try {
                      Navigator.pop(context);
                      ImagePicker picker = ImagePicker();

                      XFile? file =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (file != null) {
                        setState(() {
                          _profileImage = file;
                          _isProfileImageUpdate = true;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
      child: Avatar(
        size: 50,
        image: _profileImage,
      ),
    );
  }
}
