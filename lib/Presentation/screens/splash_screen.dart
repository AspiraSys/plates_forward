import 'package:flutter/material.dart';
import 'package:plates_forward/Utils/app_assets.dart';
import 'package:plates_forward/Utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor.primaryColor,
        child: Center(
          child: SizedBox(
            width: mq.width * 0.6,
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
}
