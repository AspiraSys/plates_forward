import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plates_forward/Presentation/screens/appScreen/donate_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/home_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/mission_screen.dart';
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

  NavigationScreen({super.key});

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.currentIndex != 0) {
          setState(() {
            widget.currentIndex = 0;
          });
          return false;
        } else {
          final now = DateTime.now();
          if (lastPressed == null ||
              now.difference(lastPressed!) > const Duration(seconds: 2)) {
            lastPressed = now;
            Fluttertoast.showToast(
              msg: "Press Back Again To Exit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColor.navBackgroundColor,
              textColor: AppColor.primaryColor,
              fontSize: 16.0,
            );
            return false;
          } else {
            return true;
          }
        }
      },
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
}
