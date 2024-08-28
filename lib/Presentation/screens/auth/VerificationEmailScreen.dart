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
import 'package:plates_forward/square/model/search_user/search_user_request.dart';
import 'package:plates_forward/square/model/search_user/search_user_response.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int _secondsRemaining = 60;

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
    _buttonTimer?.cancel();

    setState(() {
      _isButtonEnabled = false;
      _secondsRemaining = 60;
    });

    // _buttonTimer = Timer(const Duration(seconds: 60), () {
    //   setState(() {
    //     _isButtonEnabled = true;
    //   });
    // });
    _buttonTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });

      if (_secondsRemaining <= 0) {
        setState(() {
          _isButtonEnabled = true;
          timer.cancel(); // Stop the timer
        });
      }
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
    try {
      // Step 1: Search for the user in Square POS by email address
      final searchResponse = await square.searchUser(
        emailAddress: SearchUserRequest(emailAddress: email),
      );

      String? customerId;
      if(searchResponse is SearchUserModel && searchResponse.customers.isNotEmpty){
        customerId = searchResponse.customers[0].id;
         Get.find<UserController>().setUserSquareId(customerId);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('customerID', customerId);
      }else{
         final CustomerResponse? customerResponse = await square.createUser(
          emailAddress:
              CreateUserRequest(emailAddress: email, givenName: names),
        );

      if (customerResponse != null) {
        customerId = customerResponse.id;
      } else {
        print('Failed to create user in Square POS.');
        return;
      }
      }
      // Step 2: Check the search response and handle accordingly
      // if (searchResponse != null && searchResponse is SearchUserModel) {
      //   if (searchResponse.customers.isNotEmpty) {
      //     // Customer exists, get the customer ID
      //     customerId = searchResponse.customers[0].id;
      //   } else {
      //     // Customer does not exist, create a new one
      //     final CustomerResponse? customerResponse = await square.createUser(
      //       emailAddress:
      //           CreateUserRequest(emailAddress: email, givenName: names),
      //     );

      //     if (customerResponse != null) {
      //       customerId = customerResponse.id;
      //     } else {
      //       print('Failed to create user in Square POS.');
      //       return;
      //     }
      //   }
      // } else if (searchResponse is Map && searchResponse['errors'] != null) {
      //   print(
      //       'Something went wrong with Square POS: ${searchResponse['errors']}');
      //   return;
      // } else {
      //   print('Unexpected response from Square POS: $searchResponse');
      //   return;
      // }

      // Step 3: Store the customer ID in Firestore if it exists
      if (customerId.isNotEmpty) {
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
      }else{
         print('empty');
      }
    } catch (e) {
      print('An error occurred while triggering Square functionality: $e');
    }
  }

//   Future<void> triggerSquareFunctionality(email, names) async {
//     //  final res = await square.searchUser(
//     //   emailAddress: SearchUserRequest(emailAddress: email),
//     // );

// // if (res != null && res is Map && res['errors'] != null) {
// //       setState(() {
// //         errorText = 'Something went wrong with Square POS';
// //       });
// //       return;
// //     }

//     // if (res is SearchUserModel && res.customers.isNotEmpty) {
//     //   String customerId = res.customers[0].id;

//     //   Get.find<UserController>().setUserSquareId(customerId);
//     //   SharedPreferences prefs = await SharedPreferences.getInstance();
//     //   await prefs.setString('customerID', customerId);
//     //   Navigator.of(context).pushReplacementNamed(RoutePaths.navigationRoute);
//     // } else {
//     //   // ignore: use_build_context_synchronously
//     //   _showCreateSquareIdDialog(context);
//     // }
//     final CustomerResponse? customerResponse = await square.createUser(
//       emailAddress: CreateUserRequest(emailAddress: email, givenName: names),
//     );

//     if (customerResponse != null) {
//       final String customerId = customerResponse.id;

//       final String? userId = FirebaseAuth.instance.currentUser?.uid;

//       if (userId != null) {
//         await FirebaseFirestore.instance
//             .collection('MasterUserData')
//             .doc(userId)
//             .set({'squareCustomerId': customerId}, SetOptions(merge: true));

//         print(
//             'Successfully stored Square customer ID in Firestore: $customerId');
//       } else {
//         print('User ID is null.');
//       }
//     } else {
//       print('Failed to create user in Square POS.');
//     }
//   }

  void _noOp() {}

  Future<void> _resendVerificationEmail() async {
    final NetworkController networkController = Get.find<NetworkController>();

    if (!_isButtonEnabled) return; // Prevent multiple taps

    setState(() {
      _isButtonEnabled = false; // Disable the button immediately after tap
    });

    try {
      if (networkController.isConnected.value) {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email resent!'),
          ),
        );
        _startButtonTimer(); // Start the timer after the email is sent
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection!'),
          ),
        );
        setState(() {
          _isButtonEnabled = true; // Re-enable the button on failure
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Failed to send verification email, kindly try it after some time'),
        ),
      );
      setState(() {
        _isButtonEnabled = true;
      });
    }
  }

  @override
  void dispose() {
    _buttonTimer?.cancel();
    timer?.cancel();
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
              // onTap: _isButtonEnabled
              //     ? () {
              //         if (networkController.isConnected.value) {
              //           FirebaseAuth.instance.currentUser
              //               ?.sendEmailVerification();
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             const SnackBar(
              //               content: Text('Verification email resent!'),
              //             ),
              //           );

              //           _startButtonTimer();
              //         } else {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             const SnackBar(
              //               content: Text('No internet connection!'),
              //             ),
              //           );
              //         }
              //       }
              //     : null,
              onTap: _isButtonEnabled ? _resendVerificationEmail : null,
              child: Text(
                // "Resend Email".toUpperCase(),
                _isButtonEnabled
                    ? "Resend Email".toUpperCase()
                    : "Wait $_secondsRemaining seconds",
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
