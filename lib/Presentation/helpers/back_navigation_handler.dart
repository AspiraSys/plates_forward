import 'package:flutter/material.dart';

class BackNavigationHandler extends StatelessWidget {
  final Widget child;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const BackNavigationHandler({
    super.key,
    required this.child,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          return true;
        } else {
          _showExitSnackbar(context);
          return false;
        }
      },
      child: child,
    );
  }

  void _showExitSnackbar(BuildContext context) {
    // final scaffoldKey = this.scaffoldKey ?? GlobalKey<ScaffoldState>();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Are you sure you want to go out of the application?'),
        action: SnackBarAction(
          label: 'Exit',
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
