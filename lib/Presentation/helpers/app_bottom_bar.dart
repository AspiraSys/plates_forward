import 'package:flutter/material.dart';
import 'package:plates_forward/utils/app_assets.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/utils/app_routes_path.dart';

class BottomNavBar extends StatefulWidget {
  final bool isProfile;
  final int activeIcon;

  const BottomNavBar({super.key, this.isProfile = false, this.activeIcon = 0});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(RoutePaths.homeRoute);
        break;
      case 1:
        Navigator.of(context).pushNamed(RoutePaths.venueRoute);
        break;
      case 2:
        Navigator.of(context).pushNamed(RoutePaths.donateRoute);
        break;
      case 3:
        Navigator.of(context).pushNamed(RoutePaths.missionRoute);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              widget.isProfile && widget.activeIcon == 0
                  ? ImageAssets.notActiveImpactIcon
                  : widget.activeIcon == 0
                      ? ImageAssets.activeImpactIcon
                      : ImageAssets.notActiveImpactIcon,
              width: 32,
              height: 32,
            ),
            label: 'Impact',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              widget.isProfile && widget.activeIcon == 0
                  ? ImageAssets.notActiveLocationIcon
                  : widget.activeIcon == 1
                      ? ImageAssets.activeLocationIcon
                      : ImageAssets.notActiveLocationIcon,
              width: 32,
              height: 32,
            ),
            label: 'Venues',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              widget.isProfile && widget.activeIcon == 0
                  ? ImageAssets.notActiveDonateIcon
                  : widget.activeIcon == 2
                      ? ImageAssets.activeDonateIcon
                      : ImageAssets.notActiveDonateIcon,
              width: 32,
              height: 32,
            ),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              widget.isProfile && widget.activeIcon == 0
                  ? ImageAssets.notActiveMissionIcon
                  : widget.activeIcon == 3
                      ? ImageAssets.activeMissionIcon
                      : ImageAssets.notActiveMissionIcon,
              width: 32,
              height: 32,
            ),
            label: 'Mission',
          ),
        ],
        backgroundColor: AppColor.navBackgroundColor,
        currentIndex: widget.activeIcon,
        onTap: _onItemTapped,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: const Color.fromARGB(255, 64, 64, 61),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 12,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
