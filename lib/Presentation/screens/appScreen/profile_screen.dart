// import 'dart:js';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:js';

// import 'dart:js';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_sheet.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_circular.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _profilePictureUrl = '';
  late bool _isLoading = true;
  String imagesUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot<Map<String, dynamic>> userDetails =
            await FirebaseFirestore.instance
                .collection('userSignup')
                .doc(userId)
                .get();
        setState(() {
          _profilePictureUrl = userDetails['profilePicture'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> updateImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
        _profilePictureUrl = File(pickedImage.path).toString();
      });

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirProfilePictures =
          referenceRoot.child('profilePictures');
      Reference referenceImageUpload =
          referenceDirProfilePictures.child(pickedImage.name);

      try {
        await referenceImageUpload.putFile(File(pickedImage.path));
        imagesUrl = await referenceImageUpload.getDownloadURL();

        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('userSignup')
              .doc(userId)
              .update({'profilePicture': imagesUrl});
        }

        setState(() {
          _profilePictureUrl = imagesUrl;
          _isLoading = false;
        });
      } catch (err) {
        print('Error uploading image: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarScreen(
        title: 'Profile',
        subScreen: true,
        isProfile: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: updateImage,
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 50, bottom: 24),
                width: 164,
                height: 164,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(82),
                ),
                child: Stack(
                  children: [
                    _isLoading
                        ? Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : _profilePictureUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(82),
                                child: Image.network(
                                  _profilePictureUrl,
                                  width: 164,
                                  height: 164,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: AppColor.primaryColor),
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColor.whiteColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Text(
            'Jane Doe'.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(RoutePaths.accountDetailRoute),
            child: Container(
              margin: const EdgeInsets.only(top: 74, left: 30),
              child: Row(
                children: [
                  Image.asset(ImageAssets.accountIcon, width: 26, height: 25),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Account Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheets(
                      title: 'Delete Account',
                      buttonText: 'Confirm Delete',
                      content:
                          'Are you sure you want to delete your account? Once deleted, the action cannot be undone. ',
                      handleAction: _handleDelete(context),
                    );
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 40, left: 32),
              child: Row(
                children: [
                  Image.asset(ImageAssets.deleteIcon, width: 24, height: 26),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Delete Account',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          Center(
              child: ButtonBox(
                  buttonText: 'Log Out',
                  fillColor: true,
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheets(
                            title: 'LogOut',
                            buttonText: 'Confirm',
                            content:
                                'Are you sure you want to log out of your account?',
                            handleAction: () {
                              handleLogOut(context);
                            });
                      }))),
          // GestureDetector(
          //   onTap: () {
          //     showModalBottomSheet(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return const BottomSheets(
          //             title: 'LogOut',
          //             buttonText: 'Confirm',
          //             content:
          //                 'Are you sure you want to log out of your account?',
          //             handleAction: handleLogOut,
          //           );
          //         });
          //   },

          // ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        isProfile: true,
      ),
    );
  }
}

Future<void> handleLogOut(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const CircularProgress();
    },
  );

  try {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushNamedAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      RoutePaths.loginRoute,
      (route) => false,
    );
  } catch (e) {
    print("Error occurred during logout: $e");
  }
}

VoidCallback _handleDelete(BuildContext context) {
  return () {
    if (kDebugMode) {
      print('delete button clicked');
    }
    Navigator.of(context).pushNamed(RoutePaths.loginRoute);
  };
}
