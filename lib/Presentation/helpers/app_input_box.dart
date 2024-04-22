import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plates_forward/Utils/app_colors.dart';

class InputBox extends StatefulWidget {
  final String labelText;
  final String inputType;
  final dynamic inputController;
  final bool accountDetail;
  final bool disabled;
  final bool phone;

  const InputBox(
      {super.key,
      required this.labelText,
      required this.inputType,
      this.inputController,
      this.accountDetail = false,
      this.disabled = true,
      this.phone = false});

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late TextEditingController _controller;
  bool obscureText = false;
  bool showPassword = true;
  bool showText = true;

  @override
  void initState() {
    super.initState();
    if (widget.inputController is TextEditingController) {
      _controller = widget.inputController;
    } else {
      _controller = TextEditingController(text: widget.inputController ?? '');
    }
    obscureText = widget.inputType == 'password' ? true : false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.greyColor, width: 2)),
      ),
      margin: const EdgeInsets.only(top: 2),
      child: TextFormField(
        inputFormatters: widget.phone ? [PhoneNumberFormatter()] : null,
        controller: _controller,
        obscureText: widget.inputType == 'password' ? showPassword : false,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          // prefixText: widget.phone ? '+61' : '',
          // prefixStyle: const TextStyle(
          //   fontSize: 14,
          //   fontWeight: FontWeight.w400,
          //   color: AppColor.blackColor,
          //   decoration: TextDecoration.none,
          // ),
          enabled: widget.disabled,
          suffixIcon: obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                      // showText = !showText;
                      // obscureText = !showPassword;
                    });
                  },
                  child: widget.accountDetail
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            showPassword ? 'Show' : 'Hide',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Icon(
                          showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 25,
                          color: AppColor.primaryColor,
                        ),
                )
              : null,
          hintText: widget.labelText,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.greyColor,
            decoration: TextDecoration.none,
          ),
          contentPadding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text.trim().replaceAll(' ', '');

    if (formattedText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (newValue.text.length == 1) {
      formattedText = '+61${newValue.text}';
    } else if (newValue.text.length > 1 && !newValue.text.startsWith('+61')) {
      formattedText = '+61${newValue.text.substring(3)}';
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
