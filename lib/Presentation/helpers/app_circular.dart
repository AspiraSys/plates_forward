import 'package:flutter/material.dart';
import 'package:plates_forward/utils/app_colors.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }
}
