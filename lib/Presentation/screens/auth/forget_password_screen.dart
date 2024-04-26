import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/Utils/app_routes_path.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 38, bottom: 50),
            child: Image.asset(
              ImageAssets.authLogo,
              width: 157,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 40, bottom: 24),
            child: Text(
              "Reset Password".toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(2, 60, 167, 1),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: const Text(
              "Please enter your email address, s0 we will send you link to email",
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
            child: const InputBox(
              inputController: '',
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
                    _handleSendEmail();
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
            margin: const EdgeInsets.only(top: 128),
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

  _handleSendEmail() {}

  _handleSignUp() {
    Navigator.of(context).pushNamed(RoutePaths.signupRoute);
  }
}
