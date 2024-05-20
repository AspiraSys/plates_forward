import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/screens/appScreen/account_detail_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/donate_successful_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/profile_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/splash_screen.dart';
import 'package:plates_forward/Presentation/screens/auth/forget_password_screen.dart';
import 'package:plates_forward/Presentation/screens/auth/signup_screen.dart';
import 'package:plates_forward/navigation/navigation_screen.dart';
import 'package:plates_forward/presentation/Screens/auth/login_screen.dart';
import 'package:plates_forward/Utils/app_routes_path.dart';


class AppRouter {
  AppRouter._internal();
  static MaterialPageRoute? navigateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splashRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreenWithDelay(),
        );
      case RoutePaths.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case RoutePaths.signupRoute:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case RoutePaths.forgetPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => const ForgetPasswordScreen(),
        );
      case RoutePaths.navigationRoute:
        return MaterialPageRoute(
          builder: (context) => NavigationScreen(),
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
        return null;
    }
  }
}
