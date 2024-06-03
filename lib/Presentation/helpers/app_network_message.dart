import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Utils/app_colors.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnection();
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    isConnected.value = connectivityResult != ConnectivityResult.none;
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
          messageText: const Text(
            'Please Connect your Internet',
            style: TextStyle(color: AppColor.whiteColor, fontSize: 12),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: AppColor.redColor,
          icon:
              const Icon(Icons.wifi_off, color: AppColor.whiteColor, size: 32),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  Future<void> _checkInitialConnection() async {
    var result = await _connectivity.checkConnectivity();
    isConnected.value = result != ConnectivityResult.none;
  }
}
