import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_controller.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/Utils/app_routes_path.dart';
import 'package:plates_forward/square/model/create_user/create_user_request.dart';
import 'package:plates_forward/square/model/create_user/create_user_response.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:plates_forward/utils/app_assets.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({
    super.key,
  });

  @override
  State<VerificationEmail> createState() => _VerificationEmailScreens();
}

class _VerificationEmailScreens extends State<VerificationEmail> {
  late Timer timer;
  var square = SquareFunction();
  final userController = Get.find<NameController>();

  bool _isButtonEnabled = false;
  Timer? _buttonTimer;

  @override
  void initState() {
    super.initState();
    _startButtonTimer();
    timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        timer.cancel();
        await _storeUserData();
        Navigator.of(context).pushNamed(RoutePaths.loginRoute);
      }
    });
  }

  void _startButtonTimer() {
    setState(() {
      _isButtonEnabled = false;
    });

    _buttonTimer?.cancel();
    _buttonTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
  }

  Future<void> _storeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String fullNames =
          "${userController.firstName} ${userController.lastName}";
      await triggerSquareFunctionality(user.email, fullNames);
    }
  }

  Future<void> triggerSquareFunctionality(email, names) async {
    final CustomerResponse? customerResponse = await square.createUser(
      emailAddress: CreateUserRequest(emailAddress: email, givenName: names),
    );

    if (customerResponse != null) {
      final String customerId = customerResponse.id;

      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('MasterUserData')
            .doc(userId)
            .set({'squareCustomerId': customerId}, SetOptions(merge: true));

        print(
            'Successfully stored Square customer ID in Firestore: $customerId');
      } else {
        print('User ID is null.');
      }
    } else {
      print('Failed to create user in Square POS.');
    }
  }

  void _noOp() {}

  @override
  void dispose() {
    timer.cancel();
    _buttonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            child: Image.asset(
              ImageAssets.authLogo,
              width: 138,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              "Email Verification".toUpperCase(),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(2, 60, 167, 1)),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
            child: const Text(
              "The Email Verification Link has been sent to your email address. If you haven't received it, please click the below button.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 30),
            child: GestureDetector(
              onTap: _isButtonEnabled
                  ? () async {
                      if (networkController.isConnected.value) {
                        await FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification email resent!'),
                          ),
                        );

                        _startButtonTimer();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No internet connection!'),
                          ),
                        );
                      }
                    }
                  : null,
              child: Text(
                "Resend Email".toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _isButtonEnabled
                      ? AppColor.primaryColor
                      : AppColor.greyColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
