import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/utils/app_colors.dart';

class BottomSheets extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback handleAction;
  
  const BottomSheets({super.key, required this.title, required this.content, required this.handleAction, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        color: AppColor.navBackgroundColor,
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 44),
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 22),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20),
            ButtonBox(
                buttonText: buttonText,
                fillColor: true,
                onPressed: () => handleAction()
              )
          ],
        ),
      ),
    );
  }
}