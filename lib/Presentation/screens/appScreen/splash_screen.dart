import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class SplashScreenWithDelay extends StatefulWidget {
  const SplashScreenWithDelay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenWithDelayState createState() => _SplashScreenWithDelayState();
}

class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    moveToNext(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor.primaryColor,
        child: Center(
          child: SizedBox(
            //width: mq.width * 0.6,
            child: Image.asset(
              ImageAssets.appLogo,
              width: 216,
              height: 216,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void moveToNext(BuildContext context) {
    Timer(const Duration(seconds: 6), () {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed(RoutePaths.navigationRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(RoutePaths.loginRoute);
      }
    });
  }
}
