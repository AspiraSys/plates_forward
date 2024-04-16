import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/helpers/app_buttons.dart';
import 'package:plates_forward/Presentation/helpers/app_input_box.dart';
import 'package:plates_forward/utils/app_colors.dart';

class BottomSheets extends StatefulWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback handleAction;
  final bool delete;

  const BottomSheets(
      {super.key,
      required this.title,
      required this.content,
      required this.handleAction,
      required this.buttonText,
      this.delete = false});

  @override
  State<BottomSheets> createState() => _BottomSheetsState();
}

class _BottomSheetsState extends State<BottomSheets> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.delete ? 400 : 350,
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
                widget.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 22),
              child: Text(
                widget.content,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            widget.delete
                ? Container(
                    width: 300,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InputBox(
                      labelText: 'password',
                      inputType: 'password',
                      inputController: _passwordController,
                    ),
                  )
                : Container(),
            const SizedBox(height: 20),
            ButtonBox(
                buttonText: widget.buttonText,
                fillColor: true,
                onPressed: () => widget.handleAction())
          ],
        ),
      ),
    );
  }
}
