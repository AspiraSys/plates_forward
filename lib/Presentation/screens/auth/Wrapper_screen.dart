// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plates_forward/Presentation/screens/auth/VerificationEmailScreen.dart';
import 'package:plates_forward/Presentation/screens/auth/login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              print('---> ${snapshot.data}');
              return const LoginScreen();
            } else {
              if (snapshot.data?.emailVerified == true) {
                print("in else ifff");

                return const LoginScreen();
              }
              print("in else ");

              return const VerificationEmail();
            }
          }),
    );
  }
}
