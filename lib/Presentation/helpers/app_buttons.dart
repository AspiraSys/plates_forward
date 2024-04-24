// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/utils/app_assets.dart';

class ButtonBox extends StatefulWidget {
  final String buttonText;
  final bool fillColor;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool opacityColor;

  const ButtonBox({
    super.key,
    required this.buttonText,
    required this.fillColor,
    required this.onPressed,
    this.isLoading = false,
    this.opacityColor = false,
  });

  @override
  State<ButtonBox> createState() => _ButtonBox();
}

class _ButtonBox extends State<ButtonBox> {
  late bool buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.fillColor;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
          width: 176,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: buttonColor ? AppColor.primaryColor : AppColor.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: buttonColor
                  ? null
                  : Border.all(width: 1, color: AppColor.primaryColor)),
          child: Row(
            mainAxisAlignment: widget.isLoading
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              widget.isLoading
                  ? Image.asset(
                      ImageAssets.loaderIcon,
                      width: 20,
                      height: 20,
                    )
                  : Container(),
              Text(
                widget.buttonText.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: buttonColor
                        ? AppColor.whiteColor
                        : AppColor.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2),
              ),
            ],
          )),
    );
  }
}
