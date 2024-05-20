import 'package:get/get.dart';
import 'package:plates_forward/Presentation/helpers/app_network_message.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
