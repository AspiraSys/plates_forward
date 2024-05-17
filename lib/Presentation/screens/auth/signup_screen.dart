import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
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
  bool checked = false;

@override
  void initState() {
    super.initState();
    // dataTerms();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
  }

  CollectionReference<Object?> fetchStream(String collection) {
    final CollectionReference collections =
        FirebaseFirestore.instance.collection(collection);

    return collections;
  }

  // void dataTerms() {
  //   fetchStream('Terms&Conditions').snapshots().listen((snapshot) {
  //     if (snapshot.docs.isNotEmpty) {
  //       for (var document in snapshot.docs) {
  //         print('---> ${document.data()}');
  //       }
  //     } else {
  //       print('No documents found in the "Terms&Conditions" collection.');
  //     }
  //   });
  // }


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

    if (!checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColor.navBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 25),
          content: Text(
            'Kindly check the privacy and terms & conditions box.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _mobileNumberController.text.isEmpty ||
        _emailController.text.isEmpty) {
      setState(() {
        errorText = 'Please enter all the fields';
      });
      return;
    } else if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
        .hasMatch(_firstNameController.text)) {
      setState(() {
        errorText = 'Invalid First Name';
      });
      return;
    } else if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]')
        .hasMatch(_lastNameController.text)) {
      setState(() {
        errorText = 'Invalid Last Name';
      });
      return;
    } else if (_firstNameController.text.length < 3 ||
        _firstNameController.text.length > 20) {
      setState(() {
        errorText = 'First Name should be between 3 to 20 characters ';
      });
      return;
    } else if (_firstNameController.text.length < 3 ||
        _firstNameController.text.length > 20) {
      setState(() {
        errorText = 'Last Name should be between 3 to 20 characters ';
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
        errorText =
            'Password must contain One Uppercase, One Special Character and Numbers';
      });
      return;
    } else if (_mobileNumberController.text.length == 8 ||
        _mobileNumberController.text.length <= 10) {
      setState(() {
        errorText = 'Mobile number must be between 10 to 12 digits';
      });
      return;
    } else

      // ignore: curly_braces_in_flow_control_structures
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
      setState(() {
        isLoading = false;
      });
      _showSuccessDialog();

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushNamed(RoutePaths.loginRoute);
      });
    } catch (e) {
      setState(() {
        errorText = 'Please ensure you have entered a valid email address';
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text(
          'Success',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.blackColor),
        ),
        content: Text(
          'You have successfully signed up!',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor),
        ),
        backgroundColor: AppColor.navBackgroundColor,
      ),
    );
  }

  Widget buildPrivacyPolicySubUI(
      List<QueryDocumentSnapshot<Object?>> briefPolicyDataList) {
    List<Widget> policyWidgets = [];

    for (var snapshot in briefPolicyDataList) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        List<dynamic>? policyList = data['briefPolicyData'];

        if (policyList != null) {
          for (var policyItem in policyList) {
            String title = policyItem['title'] ?? '';
            List<Map<String, dynamic>> subPolicyData =
                (policyItem['subPolicyData'] as List<dynamic>)
                    .map((item) => item as Map<String, dynamic>)
                    .toList();
            String description = policyItem['description'] ?? '';

            List<Widget> subTitleWidgets = [];

            for (var subPolicyItem in subPolicyData) {
              String subTitle = subPolicyItem['subTitle'] ?? '';
              String subDescription = subPolicyItem['subDescription'] ?? '';

              subTitleWidgets.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '$subTitle : ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColor.blackColor,
                        ),
                        children: [
                          TextSpan(
                            text: subDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            }

            policyWidgets.add(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    subTitleWidgets.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subTitleWidgets,
                          )
                        : const SizedBox.shrink(),
                    description.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                description,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const Divider(),
                  ],
                ),
              ),
            );
          }
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: policyWidgets,
      ),
    );
  }

 Widget buildTermsPolicySubUI(List<dynamic> normsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: normsList.map((norm) {
        String title = norm['title'] ?? '';
        List<dynamic> detailNormList = norm['detailNorm'] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...detailNormList.map((detail) {
              String subTitle = detail['subTitle'] ?? '';
              String subDescription = detail['subDescription'] ?? '';
              Map<String, dynamic> detailDescrip =
                  detail['detailDescrip'] ?? {};

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subDescription,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    ...detailDescrip.entries.map((entry) {
                      String value = entry.value ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.circle_rounded,
                              color: AppColor.blackColor,
                              size: 4,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
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
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromARGB(79, 244, 67, 54)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              errorText = '';
                            }),
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.red,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
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
                        inputType: 'email',
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
                        inputType: 'phone',
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
                          value: checked,
                          onChanged: (newValue) {
                            setState(() {
                              checked = newValue!;
                            });
                          },
                          activeColor: checked
                              ? AppColor.primaryColor
                              : AppColor.whiteColor,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to your',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.blackColor,
                              ),
                              children: [
                                TextSpan(
                                  text: ' privacy policy ',
                                  style: const TextStyle(
                                      color: AppColor.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.22,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            backgroundColor:
                                                AppColor.navBackgroundColor,
                                            contentPadding: EdgeInsets.zero,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 24),
                                                  child: Text(
                                                    "Privacy Policy",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: fetchStream(
                                                              'privacyPolicySub')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapShot) {
                                                        if (!snapShot.hasData) {
                                                          return const Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 5),
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: AppColor
                                                                    .primaryColor,
                                                                strokeWidth: 3,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              for (var policyItem
                                                                  in snapShot
                                                                      .data!.docs)
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              10),
                                                                      child: Text(
                                                                        policyItem[
                                                                                'description'] ??
                                                                            '',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                AppColor.blackColor),
                                                                      ),
                                                                    ),
                                                                    StreamBuilder<
                                                                        QuerySnapshot>(
                                                                      stream: fetchStream(
                                                                              'privacyPolicy')
                                                                          .snapshots(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Container();
                                                                        } else {
                                                                          final briefPolicyDataList = snapshot
                                                                              .data!
                                                                              .docs;
                                                                          return buildPrivacyPolicySubUI(
                                                                              briefPolicyDataList);
                                                                        }
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              3,
                                                                          horizontal:
                                                                              15),
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                RichText(
                                                                              softWrap:
                                                                                  true,
                                                                              text:
                                                                                  TextSpan(
                                                                                text: policyItem['subTitle'] ?? '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: AppColor.blackColor,
                                                                                ),
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: ' - ${policyItem['SubDescription'] ?? ''}',
                                                                                    style: const TextStyle(
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              15),
                                                                      child: Text(
                                                                        policyItem[
                                                                                'description2'] ??
                                                                            '',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                AppColor.blackColor),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Close",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .primaryColor)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                ),
                                const TextSpan(text: 'and'),
                                TextSpan(
                                  text: ' terms & conditions. ',
                                  style: const TextStyle(
                                      color: AppColor.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.22,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                            ),
                                            backgroundColor:
                                                AppColor.navBackgroundColor,
                                            contentPadding: EdgeInsets.zero,
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 24),
                                                  child: Text(
                                                    "Terms & Conditions",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: fetchStream(
                                                              'Terms&Conditions')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapShot) {
                                                        if (!snapShot.hasData) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                          );
                                                        } else {
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              for (var termsItem
                                                                  in snapShot
                                                                      .data!.docs)
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              15,
                                                                          vertical:
                                                                              10),
                                                                      child: Text(
                                                                        termsItem[
                                                                                'description'] ??
                                                                            '',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                AppColor.blackColor),
                                                                      ),
                                                                    ),
                                                                    buildTermsPolicySubUI(
                                                                              termsItem[
                                                                                'Norms'] ?? [])
                                                                  ],
                                                                ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Close", style: TextStyle(color: AppColor.primaryColor)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(RoutePaths.loginRoute),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 4, bottom: 10),
                child: const Text(
                  "Return to SignIn",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(2, 60, 167, 1),
                  ),
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
                  // enabled: checked,
                  // opacityColor: !checked,
                )),
          ],
        ),
        if (isLoading) const CircularProgress()
      ]),
    );
  }
}
