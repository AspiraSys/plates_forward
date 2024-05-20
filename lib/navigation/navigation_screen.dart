import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/screens/appScreen/donate_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/home_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/mission_screen.dart';
// import 'package:plates_forward/Presentation/screens/appScreen/profile_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/venues_screen.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';

class NavigationScreen extends StatefulWidget {
  final screens = [
    const HomeScreen(),
    const VenueScreen(),
    const DonateScreen(),
    const MissionScreen(),
  ];

  NavigationScreen({super.key});

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: widget.screens),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              (index == 0)
                  ? ImageAssets.activeImpactIcon
                  : ImageAssets.notActiveImpactIcon,
              width: 32,
              height: 32,
            ),
            label: 'Impact',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              (index == 1)
                  ? ImageAssets.activeLocationIcon
                  : ImageAssets.notActiveLocationIcon,
              width: 32,
              height: 32,
            ),
            label: 'Venues',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              (index == 2)
                  ? ImageAssets.activeDonateIcon
                  : ImageAssets.notActiveDonateIcon,
              width: 32,
              height: 32,
            ),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              (index == 3)
                  ? ImageAssets.activeMissionIcon
                  : ImageAssets.notActiveMissionIcon,
              width: 32,
              height: 32,
            ),
            label: 'Mission',
          ),
        ],
        backgroundColor: AppColor.navBackgroundColor,
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
