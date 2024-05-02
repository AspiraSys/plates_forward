import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_sheet.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_circular.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
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
  late String _firstName = '';
  late String _lastName = '';
  late bool _isLoading = true;
  bool isDeleteLoading = false;
  String imagesUrl = '';
  TextEditingController passwordController = TextEditingController();
  String errorText = '';
  String emailController = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
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
          _firstName = userDetails['firstName'];
          _lastName = userDetails['lastName'];
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

  Future<void> handleConfirmDelete(BuildContext context) async {
    String password = passwordController.text;

    if (password.isEmpty) {
      setState(() {
        errorText = 'Enter the valid password';
      });
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not authenticated");
      return;
    }

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await FirebaseFirestore.instance
              .collection('userSignup')
              .doc(userId)
              .get();

      String email = userDetails['email'];

      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      try {
        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, delete the user's account
        await user.delete();
        print('deleted');
        await Future.delayed(const Duration(seconds: 2), () {
          isDeleteLoading = true;
          setState(() {
            isDeleteLoading = false;
          });
        });
        // await deleteUserData(userId);
        // Navigate to the login page
        Navigator.pushNamed(context, RoutePaths.loginRoute);
        setState(() {
          errorText = '';
        });
      } catch (e) {
        setState(() {
          errorText = 'Password is invalid';
        });
        print('Error: $e');
      }
    }
  }

  // Future<void> deleteUserData(String userId) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   QuerySnapshot collections = await firestore.collectionGroup().get();
  // for (QueryDocumentSnapshot collection in collections.docs) {
  //     CollectionReference collectionRef =
  //         firestore.collection(collection.reference.path);
  //     QuerySnapshot userDocs =
  //         await collectionRef.where('userId', isEqualTo: userId).get();
  //     for (QueryDocumentSnapshot doc in userDocs.docs) {
  //       await doc.reference.delete();
  //     }
  //   }
  // }

  VoidCallback _handleDelete(BuildContext context) {
    print("---> $errorText");

    return () async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.navBackgroundColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Please Confirm Your Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RoutePaths.profileRoute);
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.blackColor,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColor.whiteColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InputBox(
                        labelText: 'Enter password',
                        inputType: 'password',
                        inputController: passwordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        errorText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColor.redColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ButtonBox(
                      buttonText: 'Confirm Delete',
                      fillColor: true,
                      onPressed: () => handleConfirmDelete(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarScreen(
        title: 'Profile',
        subScreen: true,
        isProfile: true,
      ),
      body: isDeleteLoading
          ? const CircularProgress()
          : Column(
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
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                )
                              : Stack(
                                      children: [
                                         _profilePictureUrl.isNotEmpty
                                          ?
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(82),
                                          child: Image.network(
                                            _profilePictureUrl,
                                            width: 164,
                                            height: 164,
                                            fit: BoxFit.cover,
                                          ),
                                        ) :  ClipRRect(
                                        borderRadius: BorderRadius.circular(82),
                                        child: Image.asset(
                                          ImageAssets.placeholderProfile,
                                          width: 164,
                                          height: 164,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                                color: AppColor.primaryColor),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: AppColor.whiteColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        _firstName.toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      _lastName.toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(RoutePaths.accountDetailRoute),
                  child: Container(
                    margin: const EdgeInsets.only(top: 74, left: 30),
                    child: Row(
                      children: [
                        Image.asset(ImageAssets.accountIcon,
                            width: 26, height: 25),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Account Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
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
                                'Are you sure you want to delete your account? Once deleted, the action cannot be undone.',
                            handleAction: _handleDelete(context),
                          );
                        });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 40, left: 32),
                    child: Row(
                      children: [
                        Image.asset(ImageAssets.deleteIcon,
                            width: 24, height: 26),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
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

// VoidCallback _handleDelete(BuildContext context) {
//   return () async {
//     TextEditingController passwordController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Center(
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: AppColor.navBackgroundColor,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(
//                         'Please Confirm Your Password',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.primaryColor,
//                         ),
//                       ),
//                       Icon(
//                           Icons.close,
//                           color: AppColor.whiteColor,
//                           size: 15,
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: InputBox(
//                       labelText: 'Enter password',
//                       inputType: 'password',
//                       inputController: passwordController,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   ButtonBox(
//                     buttonText: 'Confirm Delete',
//                     fillColor: true,
//                     onPressed: () =>
//                         handleConfirmDelete(passwordController.text, context),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   };
// }

// Future<void> handleConfirmDelete(BuildContext context) async {

// }

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
    print("Error occurred during logout");
  }
}
