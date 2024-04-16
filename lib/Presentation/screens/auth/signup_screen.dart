import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/users_data.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_circular.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorText = '';
  bool isLoading = false;
  File? _pickedImage;
  String imagesUrl = '';

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirProfilePictures =
          referenceRoot.child('profilePictures');

      Reference referenceImageUpload =
          referenceDirProfilePictures.child(pickedImage.name);

      try {
        await referenceImageUpload.putFile(File(pickedImage.path));
        imagesUrl = await referenceImageUpload.getDownloadURL();
      } catch (err) {
        print('not downloaded properly $err');
      }
    }
  }

  Future<void> _handleSignUp() async {
    setState(() {
      errorText = '';
    });

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _mobileNumberController.text.isEmpty ||
        _emailController.text.isEmpty) {
      setState(() {
        errorText = 'Please enter all the fields';
      });
      return;
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        errorText = 'Please enter a valid email address';
      });
      return;
    } else if (_passwordController.text.length < 8) {
      setState(() {
        errorText = 'Please enter at least 8 characters for the password';
      });
      return;
    } else if (!validatePasswordStructure(_passwordController.text)) {
      setState(() {
        errorText = 'Password must contain Uppercase, Special Character';
      });
      return;
    } else if (_mobileNumberController.text.length <= 9) {
      setState(() {
        errorText = 'Please enter at 10 digit of mobile number';
      });
    }

    setState(() {
      isLoading = true;
    });

    final isEmailExists =
        await isEmailAlreadyExists(_emailController.text.trim());

    if (isEmailExists) {
      setState(() {
        errorText = 'The email address is already in use';
        isLoading = false;
      });
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String userId = userCredential.user!.uid;

      await addUserDetails(userId);

      Navigator.of(context).pushNamed(RoutePaths.loginRoute);
    } catch (e) {
      print('Error signing up: $e');
      setState(() {
        errorText = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addUserDetails(String userId) async {
    UsersData userData = UsersData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobileNumber: int.parse(_mobileNumberController.text.trim()),
      email: _emailController.text.trim(),
      profilePicture: imagesUrl,
    );

    Map<String, dynamic> userDataJson = userData.toJson();

    try {
      await FirebaseFirestore.instance
          .collection('userSignup')
          .doc(userId)
          .set(userDataJson);
    } catch (e) {
      setState(() {
        errorText = 'An error occurred. Please try again later.';
      });
    }
  }

  Future<bool> isEmailAlreadyExists(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('userSignup')
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  bool validatePasswordStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 38, bottom: 20),
              child: Image.asset(
                ImageAssets.authLogo,
                width: 138,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 20, bottom: 0),
              child: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(2, 60, 167, 1),
                ),
              ),
            ),
            errorText.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromARGB(79, 244, 67, 54)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              errorText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 5),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              color: AppColor.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              _pickedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(
                                        _pickedImage!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.asset(
                                        ImageAssets.placeholderProfile,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "First Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InputBox(
                        inputController: _firstNameController,
                        labelText: 'Enter your first name',
                        inputType: 'text',
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Last Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InputBox(
                        inputController: _lastNameController,
                        labelText: 'Enter your last name',
                        inputType: 'text',
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InputBox(
                        inputController: _emailController,
                        labelText: 'Enter your email here',
                        inputType: 'text',
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Mobile Number",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InputBox(
                        inputController: _mobileNumberController,
                        labelText: 'Enter your mobile name',
                        inputType: 'text',
                        phone: true,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InputBox(
                          inputController: _passwordController,
                          labelText: 'Enter your password here',
                          inputType: 'password'),
                    ),
                    Row(
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20)),
                        Checkbox(
                          value: true,
                          onChanged: (newValue) {},
                          activeColor: AppColor.primaryColor,
                        ),
                        RichText(
                            text: const TextSpan(
                                text: 'I agree to your',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.blackColor,
                                ),
                                children: <TextSpan>[
                              TextSpan(
                                  text: ' privacy policy ',
                                  style:
                                      TextStyle(color: AppColor.primaryColor)),
                              TextSpan(text: 'and'),
                              TextSpan(
                                  text: ' terms & conditions. ',
                                  style:
                                      TextStyle(color: AppColor.primaryColor))
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: ButtonBox(
                  buttonText: 'Sign up',
                  fillColor: true,
                  onPressed: _handleSignUp,
                )),
          ],
        ),
        if (isLoading) const CircularProgress()
      ]),
    );
  }
}
