// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_circular.dart';
import 'package:plates_forward/Presentation/helpers/app_controller.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
import 'package:plates_forward/Utils/app_assets.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/square/model/create_user/create_user_request.dart';
import 'package:plates_forward/square/model/create_user/create_user_response.dart';
import 'package:plates_forward/square/model/search_user/search_user_request.dart';
import 'package:plates_forward/square/model/search_user/search_user_response.dart';
import 'package:plates_forward/square/square_function.dart';
import 'package:plates_forward/utils/app_routes_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var square = SquareFunction();

  String errorText = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Check authentication state when the widget initializes
    // checkAuthState();
    // fetchStripe();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _handleSignIn() async {
    final String email = _emailController.text;
    final res = await square.searchUser(
      emailAddress: SearchUserRequest(emailAddress: email),
    );

    setState(() {
      errorText = '';
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorText = "Please fill the fields";
      });
      return;
    }

    if (res != null && res is Map && res['errors'] != null) {
      setState(() {
        errorText = 'Something went wrong with Square POS';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        if (res is SearchUserModel && res.customers.isNotEmpty) {
          // if(customerId.isEmpty){
          //       print('--> check empty fields $customerId');
          // } else {
          String customerId = res.customers[0].id;

          print('--> check customerID $customerId');
          Get.find<UserController>().setUserSquareId(customerId);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('customerID', customerId);
          Navigator.of(context)
              .pushReplacementNamed(RoutePaths.navigationRoute);
        } else {
          // ignore: use_build_context_synchronously
          _showCreateSquareIdDialog(context);
          // String customerId = res.customers[0].id;
          // print('--> check empty fields $res');
          // setState(() {
          //   errorText = 'Something went wrong with Square POS.';
          // });
        }
      }
    } catch (e) {
      print('Error signing in: $e');
      setState(() {
        errorText = 'Email or Password is incorrect';
      });
    } finally {
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showCreateSquareIdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.navBackgroundColor,
          title: const Text('Kindly Create Square ID'),
          content: const Text(
              'You don\'t have a Square ID. Are you ready to create one?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColor.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Create',
                style: TextStyle(color: AppColor.primaryColor),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await createNewSquareId();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> createNewSquareId() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> userDetails =
          await FirebaseFirestore.instance
              .collection('userSignup')
              .doc(userId)
              .get();

      final String fullName =
          "${userDetails['firstName']} ${userDetails['lastName']}";
      final String givenName = fullName;
      final resp = await square.createUser(
        emailAddress: CreateUserRequest(
            emailAddress: _emailController.text, givenName: givenName),
      );

      if (resp is CustomerResponse && resp.id.isNotEmpty) {
        print("Customer created ID: ${resp.id}");
          String newCustomerId = resp.id;
                Get.find<UserController>().setUserSquareId(newCustomerId);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('customerID', newCustomerId);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColor.navBackgroundColor,
              title: const Text('Square ID Created'),
              content: const Text(
                  'Successfully created a Square ID.'),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(RoutePaths.navigationRoute);
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("in else point of view");
      }
    } else {
      setState(() {
        errorText = 'User is not authenticated.';
      });
    }
  }


  // Future<void> createNewSquareId() async {
  //   String? userId = FirebaseAuth.instance.currentUser?.uid;

  //   if (userId != null) {
  //     DocumentSnapshot<Map<String, dynamic>> userDetails =
  //         await FirebaseFirestore.instance
  //             .collection('userSignup')
  //             .doc(userId)
  //             .get();
  //     final String fullName =
  //         "${userDetails['firstName']} ${userDetails['lastName']}";
  //     final String givenName = fullName;
  //     final resp = await square.createUser(
  //       emailAddress: CreateUserRequest(
  //           emailAddress: _emailController.text, givenName: givenName),
  //     );
      
  //     if(resp.containsKey('id')){
  //             print("----> $resp");
  //              print("area point");
  //               print("----> ${resp['id']}");
  //     }else{
  //       print("in elser point of view");
  //     }
  //     print("----> $resp");
  //     print("----> ${resp['id']}");

  //     // if (res != null && res is Map<String, dynamic> && res.containsKey('id')) {
  //     //   print('Customer created ID: ${res['id']}');

  //     //   // Show success dialog and redirect to login
  //     //   showDialog(
  //     //     context: context,
  //     //     builder: (BuildContext context) {
  //     //       return AlertDialog(
  //     //         backgroundColor: AppColor.navBackgroundColor,
  //     //         title: const Text('Square ID Created'),
  //     //         content: const Text(
  //     //             'Successfully created a Square ID. Please log in.'),
  //     //         actions: <Widget>[
  //     //           TextButton(
  //     //             child: const Text(
  //     //               'OK',
  //     //               style: TextStyle(color: AppColor.primaryColor),
  //     //             ),
  //     //             onPressed: () {
  //     //               _handleSignIn();
  //     //               // Navigator.of(context).pop();
  //     //               // Navigator.of(context)
  //     //               //     .pushReplacementNamed(RoutePaths.loginRoute);
  //     //             },
  //     //           ),
  //     //         ],
  //     //       );
  //     //     },
  //     //   );
  //     // } else {
  //     //   print('Failed to create Square ID');
  //     //   setState(() {
  //     //     errorText = 'Failed to create Square ID. Please try again.';
  //     //   });
  //     // }

  //     //   if (res is SearchUserModel && res.customers.isNotEmpty) {
  //     //     String newCustomerId = res.customers[0].id;
  //     //     Get.find<UserController>().setUserSquareId(newCustomerId);
  //     //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //     await prefs.setString('customerID', newCustomerId);
  //     //     print('customer create ID $newCustomerId');
  //     //     // Navigator.of(context).pushReplacementNamed(RoutePaths.navigationRoute);
  //     //   } else {
  //     //      print('in else area create ID');
  //     //     // setState(() {
  //     //     //   errorText = 'Failed to create Square ID. Please try again.';
  //     //     // });
  //     //   }
  //     // } else {
  //     //   setState(() {
  //     //     errorText = 'User is not authenticated.';
  //     //   });
  //     // if (res != null && res is Map && res['errors'] != null) {
  //     //   // Handling the error from Square POS
  //     //   setState(() {
  //     //     errorText = 'Something went wrong with Square POS';
  //     //     isLoading = false;
  //     //   });
  //     //   return;
  //     // } else {
  //     //   String newCustomerId = res['id'];
  //     //   print('in else area create ID $newCustomerId');
  //     //   Get.find<UserController>().setUserSquareId(newCustomerId);
  //     //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //   await prefs.setString('customerID', newCustomerId);
  //     //   print('customer create ID $newCustomerId');
  //     //   // Optionally navigate to another screen here
  //     //   // Navigator.of(context).pushReplacementNamed(RoutePaths.navigationRoute);
  //     // }
  //     // if (res != null && res is Map<String, dynamic> && res.containsKey('id')) {
  //     //     String newCustomerId = res['id'];
  //     //     Get.find<UserController>().setUserSquareId(newCustomerId);
  //     //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     //     await prefs.setString('customerID', newCustomerId);
  //     //     print('customer create ID $newCustomerId');
  //     //     // Optionally navigate to another screen here
  //     //     Navigator.of(context).pushReplacementNamed(RoutePaths.navigationRoute);
  //     //   } else {
  //     //     print('in else area create ID');
  //     //     setState(() {
  //     //       errorText = 'Failed to create Square ID. Please try again.';
  //     //     });
  //     //   }
  //   } else {
  //     setState(() {
  //       errorText = 'User is not authenticated.';
  //     });
  //   }
  // }
  // Future<void> _handleSignIn() async {

  //   final String email = _emailController.text;
  //   final res = await square.searchUser(
  //     emailAddress: SearchUserRequest(emailAddress: email),
  //   );

  //   setState(() {
  //     errorText = '';
  //   });

  //   if (_emailController.text == '' || _passwordController.text == "") {
  //     setState(() {
  //       errorText = "Please fill the fields";
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     try {
  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );

  //       // ignore: unnecessary_null_comparison
  //       if (userCredential != null) {
  //         // ignore: use_build_context_synchronously
  //         Navigator.of(context)
  //             .pushReplacementNamed(RoutePaths.navigationRoute);
  //       }
  //     } catch (e) {
  //       print('Error signing in: $e');
  //       setState(() {
  //         errorText = 'Invalid User Credentials';
  //       });
  //     } finally {
  //       await Future.delayed(const Duration(seconds: 3));
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Stack(children: [
          ListView(
            padding: const EdgeInsets.all(40),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 38, bottom: 15),
                child: Image.asset(
                  ImageAssets.authLogo,
                  width: 138,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  "Sign In".toUpperCase(),
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
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 25),
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
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 30),
                  child: ButtonBox(
                      buttonText: 'Log In',
                      fillColor: true,
                      onPressed: () {
                        networkController.isConnected.value
                            ? _handleSignIn()
                            : null;
                      })),
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(RoutePaths.forgetPasswordRoute),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 24),
                  child: const Text(
                    "Forget password",
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
                padding: const EdgeInsets.only(top: 25),
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
          if (isLoading) const CircularProgress()
        ]));
  }

  _handleSignUp() {
    Navigator.of(context).pushNamed(RoutePaths.signupRoute);
  }
}
