import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_circular.dart';
import 'package:plates_forward/Utils/app_assets.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController =
      TextEditingController(text: 'arun@yopmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'Arun1234@');

  String errorText = '';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      errorText = '';
    });

    if (_emailController.text == '' || _passwordController.text == "") {
      setState(() {
        errorText = "Please fill the fields";
      });
    } else {
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
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushNamed(RoutePaths.homeRoute);
        }
      } catch (e) {
        print('Error signing in: $e');
        setState(() {
          errorText = 'Invalid User Credentials';
        });
      } finally {
        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Stack(children: [
          ListView(
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
                padding: const EdgeInsets.only(top: 30, bottom: 24),
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
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
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
                        _handleSignIn();
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
                padding: const EdgeInsets.only(top: 48),
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
