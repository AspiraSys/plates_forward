// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class ConnectivityProvider extends ChangeNotifier {
//   bool _isConnected = true;
//   bool get isConnected => _isConnected;

//   ConnectivityProvider() {
//     _initConnectivity();
//   }

//   void _initConnectivity() async {
//     final ConnectivityResult result = await Connectivity().checkConnectivity();
//     _updateConnectionStatus(result);

//     Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     _isConnected = result != ConnectivityResult.none;
//     notifyListeners();
//   }
// }
