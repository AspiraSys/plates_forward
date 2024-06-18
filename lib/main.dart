import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_controller.dart';
import 'package:plates_forward/depedency_injector.dart';
import 'package:plates_forward/models/secret_key.dart';
// import 'package:plates_forward/navigation/navigation_screen.dart';
import 'package:plates_forward/utils/app_colors.dart';
import 'package:plates_forward/utils/app_router.dart';
import 'package:plates_forward/utils/app_routes_path.dart';
import 'package:plates_forward/http_base/constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
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

  StripeKeys? stripeKeys = await fetchStripeKeys();
  Get.put(UserController());
  
  if (stripeKeys != null) {
    Stripe.publishableKey = stripeKeys.publishableKey;
    UrlConstants.token = stripeKeys.squareKey;
    await Stripe.instance.applySettings();
    runApp(const MyApp());
  } else {
    // Handle the case where stripeKeys is null
    print("Stripe keys not found in Firebase.");
  }
}

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plate It Forward',
      theme: ThemeData(primaryColor: AppColor.primaryColor),
      initialRoute: RoutePaths.splashRoute,
      // home: NavigationScreen() ,
      onGenerateRoute: AppRouter.navigateRoute,
    );
  }
}
