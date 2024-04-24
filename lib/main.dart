import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plates_forward/Utils/app_colors.dart';
import 'package:plates_forward/Utils/app_router.dart';
import 'package:plates_forward/Utils/app_routes_path.dart';
import 'package:plates_forward/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plates_forward/stripe/constants.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);

  /// Stripe Setup
  Stripe.publishableKey = StripeConstants.publishableKey;
  await Stripe.instance.applySettings();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plate It Forward',
      theme: ThemeData(
        primaryColor: AppColor.primaryColor
      ),
      initialRoute: RoutePaths.splashRoute,
      // initialRoute: RoutePaths.splashRoute,
      // navigatorObservers: [AppNavigatorObserver()],
      onGenerateRoute: AppRouter.navigateRoute
    );
  }
}
