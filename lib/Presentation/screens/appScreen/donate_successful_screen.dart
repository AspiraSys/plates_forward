import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_bar.dart';
import 'package:plates_forward/Presentation/helpers/app_bottom_bar.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

class DonateSuccessfulScreen extends StatelessWidget {
  const DonateSuccessfulScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarScreen(
        title: '',
        subScreen: true,
        isMission: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              ImageAssets.successMealIcon,
              width: 164,
              height: 144,
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                'Thanks for your generosity and support!'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Your meal donation has been successfully verified. Thanks to your contribution we can create dignity and unity through food by providing nourishing meals, creating job opportunities for our team, and tackling food insecurity in communities that need it most.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(activeIcon: 2,),
    );
  }
}
