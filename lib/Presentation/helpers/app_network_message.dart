// import 'package:flutter/material.dart';
// import 'package:plates_forward/utils/app_colors.dart';
// import 'package:provider/provider.dart';
// import 'package:plates_forward/utils/app_connectivity.dart';

// class NetworkAwareWidget extends StatefulWidget {
//   final Widget child;

//   const NetworkAwareWidget({super.key, required this.child});

//   @override
//   // ignore: library_private_types_in_public_api
//   _NetworkAwareWidgetState createState() => _NetworkAwareWidgetState();
// }

// class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final connectivityProvider =
//           Provider.of<ConnectivityProvider>(context, listen: false);
//       connectivityProvider.addListener(_showConnectivitySnackBar);
//     });
//   }

//   @override
//   void dispose() {
//     final connectivityProvider =
//         Provider.of<ConnectivityProvider>(context, listen: false);
//     connectivityProvider.removeListener(_showConnectivitySnackBar);
//     super.dispose();
//   }

//   void _showConnectivitySnackBar() {
//     final connectivityProvider =
//         Provider.of<ConnectivityProvider>(context, listen: false);
//     if (!connectivityProvider.isConnected) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No Internet Connection', style: TextStyle(color: AppColor.blackColor, fontSize: 10),),
//           backgroundColor: AppColor.redColor,
//           behavior: SnackBarBehavior.floating,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ConnectivityProvider>(
//       builder: (context, connectivity, child) {
//         return child!;
//       },
//       child: widget.child,
//     );
//   }
// }

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plates_forward/Utils/app_colors.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
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
}
