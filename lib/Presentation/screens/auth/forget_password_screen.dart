import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
import 'package:plates_forward/Utils/app_routes_path.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  String errorText = '';
  bool successText = false;
  bool isLoading = false;
  List<String> allEmails = [];

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchAndPrintEmails();
  }

  Future<void> _fetchAndPrintEmails() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('userSignup').get();

      List<String> emails =
          querySnapshot.docs.map((doc) => doc['email'] as String).toList();

      setState(() {
        allEmails = emails;
      });
    } catch (e) {
      print("Failed to fetch emails: $e");
    }
  }

  Future<void> _handleSendEmail() async {
    setState(() {
      errorText = '';
      isLoading = true;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        errorText = "Please fill in the email field";
        isLoading = false;
      });
      return;
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        errorText = 'Please enter a valid email address';
        isLoading = false;
      });
      return;
    }

    if (!allEmails.contains(_emailController.text.trim())) {
      setState(() {
        errorText = 'If the provided email is registered, a link will be sent';
        isLoading = false;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      setState(() {
        errorText = 'Successfully email sent';
        successText = true;
      });

      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushNamed('/login');
    } catch (e) {
      setState(() {
        errorText =
            'Failed to send password reset email. Please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 38, bottom: 25),
            child: Image.asset(
              ImageAssets.authLogo,
              width: 138,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Text(
              "Reset Password".toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(2, 60, 167, 1),
              ),
            ),
          ),
          errorText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: successText
                            ? const Color.fromARGB(255, 31, 86, 33)
                            : const Color.fromARGB(79, 244, 67, 54)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            errorText = '';
                          }),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: successText
                                ? AppColor.whiteColor
                                : Colors.red,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            errorText,
                            style: TextStyle(
                                fontSize: 16,
                                color: successText
                                    ? AppColor.whiteColor
                                    : Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: const Text(
              "Please enter your email for a reset link to be sent",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
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
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 30),
              child: ButtonBox(
                  buttonText: 'Send',
                  fillColor: true,
                  onPressed: () {
                    networkController.isConnected.value
                        ? _handleSendEmail()
                        : null;
                  })),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(RoutePaths.loginRoute),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 24),
              child: const Text(
                "Return to Sign In",
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
            margin: const EdgeInsets.only(top: 25),
            child: const Text(
              "Don't have an account yet?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.blackColor,
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: ButtonBox(
                buttonText: 'Sign up',
                fillColor: false,
                onPressed: () {
                  _handleSignUp();
                },
              )),
        ],
      ),
    );
  }

  _handleSignUp() {
    Navigator.of(context).pushNamed(RoutePaths.signupRoute);
  }
}
