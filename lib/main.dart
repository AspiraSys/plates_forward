// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:plates_forward/Presentation/helpers/app_network_message.dart';
// import 'package:plates_forward/Utils/app_colors.dart';
// import 'package:plates_forward/Utils/app_router.dart';
// import 'package:plates_forward/Utils/app_routes_path.dart';
// import 'package:plates_forward/firebase_options.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:plates_forward/stripe/constants.dart';
// // import 'package:provider/provider.dart';
// // import 'package:plates_forward/utils/app_connectivity.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await FirebaseAppCheck.instance.activate(
//     webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
//     androidProvider: AndroidProvider.debug,
//     appleProvider: AppleProvider.appAttest,
//   );

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitUp,
//   ]);

//   /// Stripe Setup
//   Stripe.publishableKey = StripeConstants.publishableKey;

//   print('in publishableKey ${Stripe.publishableKey}');
//   print('in secretKey ${StripeConstants.publishableKey}');
//   await Stripe.instance.applySettings();
//   await dotenv.load(fileName: ".env");

//   runApp(const MyApp());
//   //  runApp(
//   //   ChangeNotifierProvider(
//   //     create: (context) => ConnectivityProvider(),
//   //     child: const MyApp(),
//   //   ),
//   // );
//   //  runApp(
//   //   MultiProvider(
//   //     providers: [
//   //       ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
//   //     ],
//   //     child: const MyApp(),
//   //   ),
//   // );
// }

// // ignore: use_key_in_widget_constructors
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
// // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Plate It Forward',
//         theme: ThemeData(primaryColor: AppColor.primaryColor),
//         initialRoute: RoutePaths.splashRoute,
//         // initialRoute: RoutePaths.splashRoute,
//         // navigatorObservers: [AppNavigatorObserver()],
//         onGenerateRoute: AppRouter.navigateRoute);
//   }
//   // Widget build(BuildContext context) {
//   //   return MaterialApp(
//   //     title: 'Plate It Forward',
//   //     theme: ThemeData(primaryColor: AppColor.primaryColor),
//   //     initialRoute: RoutePaths.splashRoute,
//   //     onGenerateRoute: AppRouter.navigateRoute,
//   //     builder: (context, child) {
//   //       return NetworkAwareWidget(
//   //         child: child!,
//   //         //  child: ScaffoldMessenger(
//   //         //   child: Scaffold(
//   //         //     body: child!,
//   //         //   ),
//   //         // ),
//   //       );
//   //     },
//   //   );
//   // }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plates_forward/Presentation/screens/appScreen/home_screen.dart';
import 'package:plates_forward/Presentation/screens/appScreen/venues_screen.dart';
import 'package:plates_forward/models/secret_key.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/utils/app_router.dart';
import 'package:plates_forward/utils/app_routes_path.dart';
import 'package:plates_forward/http_base/constants.dart';
import 'firebase_options.dart';

void main() async {
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

  // Fetch Stripe keys from Firebase
  StripeKeys? stripeKeys = await fetchStripeKeys();

  if (stripeKeys != null) {
    Stripe.publishableKey = stripeKeys.publishableKey;
    UrlConstants.token = stripeKeys.squareKey;
    await Stripe.instance.applySettings();
    print('in publishableKey ${Stripe.publishableKey}');
    print('in secret Key ${stripeKeys.secretKey}');
    print('in square secret Key ${stripeKeys.squareKey}');
    runApp(const MyApp());
  } else {
    // Handle the case where stripeKeys is null
    print("Stripe keys not found in Firebase.");
  }
}

// Function to fetch Stripe keys from Firebase
Future<StripeKeys?> fetchStripeKeys() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await firestore.collection('secretKeys').get();

  if (querySnapshot.docs.isNotEmpty) {
    // Assuming you want to use the first document
    Map<String, dynamic> data = querySnapshot.docs.first.data();
    return StripeKeys.fromMap(data);
  } else {
    return null;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plate It Forward',
      theme: ThemeData(primaryColor: AppColor.primaryColor),
      initialRoute: RoutePaths.splashRoute,
      onGenerateRoute: AppRouter.navigateRoute,
      // home: WillPopScope(
      //   onWillPop: () async {
      //     // Handle back navigation here
      //     return false; // Return true to allow back navigation, false to prevent it
      //   },
      //   child: Navigator(
      //     initialRoute: RoutePaths.splashRoute,
      //     onGenerateRoute: (settings) {
      //       if (settings.name == RoutePaths.splashRoute) {
      //         return MaterialPageRoute(
      //           builder: (context) => const SplashScreenWithDelay(),
      //         );
      //       }
      //       return MaterialPageRoute(
      //         builder: (context) => Container(),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
