// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plates_forward/Presentation/screens/appScreen/donate_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/home_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/mission_screen.dart';
// <<<<<<< HEAD
// import 'package:plates_forward/Presentation/screens/appScreen/profile_screen.dart';
// =======
// >>>>>>> a4154b423fb04ddd4702ce667db37be6301e9ea3.
import 'package:plates_forward/Presentation/screens/appScreen/venues_screen.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

// ignore: must_be_immutable
class NavigationScreen extends StatefulWidget {
  final screens = [
    const HomeScreen(),
    const VenueScreen(),
    const DonateScreen(),
    const MissionScreen(),
  ];
  var ctime;
  var currentIndex = 0;
  bool canPope = false;

  NavigationScreen({super.key});

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPope,
      onPopInvoked: onBackPressed,
      /*(bool didPop) async {
        final bool shouldPop = onBackPressed(context);
        if(shouldPop){
          return true;
        }
      },*/
      /*onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },*/
      child: Scaffold(
        body:
            IndexedStack(index: widget.currentIndex, children: widget.screens),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                (widget.currentIndex == 0)
                    ? ImageAssets.activeImpactIcon
                    : ImageAssets.notActiveImpactIcon,
                width: 32,
                height: 32,
              ),
              label: 'Impact',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                (widget.currentIndex == 1)
                    ? ImageAssets.activeLocationIcon
                    : ImageAssets.notActiveLocationIcon,
                width: 32,
                height: 32,
              ),
              label: 'Venues',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                (widget.currentIndex == 2)
                    ? ImageAssets.activeDonateIcon
                    : ImageAssets.notActiveDonateIcon,
                width: 32,
                height: 32,
              ),
              label: 'Donate',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                (widget.currentIndex == 3)
                    ? ImageAssets.activeMissionIcon
                    : ImageAssets.notActiveMissionIcon,
                width: 32,
                height: 32,
              ),
              label: 'Mission',
            ),
          ],
          backgroundColor: AppColor.navBackgroundColor,
          currentIndex: widget.currentIndex,
          onTap: (index) {
            setState(() {
              widget.currentIndex = index;
            });
          },
          enableFeedback: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  bool onBackPressed(context) {
    /// Move to home screen
    if (widget.currentIndex != 0) {
      setState(() {
        widget.currentIndex = 0;
      });
      return false;
    }

    /// Exit app
    else {
      DateTime now = DateTime.now();
      if (widget.ctime == null ||
          now.difference(widget.ctime) > const Duration(seconds: 2)) {
        widget.ctime = now;
        Fluttertoast.showToast(
            msg: "Press Back Again To Exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: AppColor.primaryColor,
            fontSize: 16.0);
        return widget.canPope;
      } else {
        setState(() {
          widget.canPope = true;
        });
        return widget.canPope;
      }
    }
  }
/*  Future<bool?> _showBackDialog(BuildContext parContext) {
    return showDialog<bool>(
      context: parContext,
      builder: (BuildContext parContext) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(parContext).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(parContext, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(parContext).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(parContext, true);
              },
            ),
          ],
        );
      },
    );
  }*/
}
