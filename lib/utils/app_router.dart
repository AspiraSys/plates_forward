import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/screens/appScreen/account_detail_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/donate_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/donate_successful_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/home_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/mission_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/profile_screen.dart';
// import 'package:plates_forward/Presentation/screens/appScreen/venues_detail_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/venues_screen.dart';
import 'package:plates_forward/Presentation/screens/auth/forget_password_screen.dart';
import 'package:plates_forward/Presentation/screens/auth/signup_screen.dart';
import 'package:plates_forward/presentation/Screens/auth/login_screen.dart';
import 'package:plates_forward/presentation/Screens/splash_screen.dart';
// import 'package:plates_forward/Presentation/Screens/splash_screen.dart';
import 'package:plates_forward/Utils/app_routes_path.dart';
// import 'app_routes_path.dart';

class AppRouter {
  AppRouter._internal();
  static Route<dynamic> navigateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splashRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreenWithDelay(),
        );
      case RoutePaths.loginRoute:
        return MaterialPageRoute(
          builder: (context) {
            FirebaseAuth auth = FirebaseAuth.instance;
            User? user = auth.currentUser;

            if (user != null) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        );

      case RoutePaths.signupRoute:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case RoutePaths.forgetPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => const ForgetPasswordScreen(),
        );
      case RoutePaths.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case RoutePaths.venueRoute:
        return MaterialPageRoute(
          builder: (context) => const VenueScreen(),
        );
      case RoutePaths.donateRoute:
        return MaterialPageRoute(
          builder: (context) => const DonateScreen(),
        );
      case RoutePaths.missionRoute:
        return MaterialPageRoute(
          builder: (context) => const MissionScreen(),
        );
      case RoutePaths.profileRoute:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );
      case RoutePaths.accountDetailRoute:
        return MaterialPageRoute(
          builder: (context) => const AccountDetailScreen(),
        );
      // case RoutePaths.venueDetailRoute:
      //   return MaterialPageRoute(
      //     builder: (context) => const VenueDetailScreen(),
      //   );
      case RoutePaths.donateSuccessRoute:
        return MaterialPageRoute(
          builder: (context) => const DonateSuccessfulScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}

class SplashScreenWithDelay extends StatefulWidget {
  const SplashScreenWithDelay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenWithDelayState createState() => _SplashScreenWithDelayState();
}

class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen after 6 seconds
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacementNamed(RoutePaths.loginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const Center(
        child: SplashScreen(),
        // child: CircularProgressIndicator()
      ),
    );
  }
}
