import 'package:get/get.dart';

class UserController extends GetxController {
  var userSquareId = ''.obs;

  void setUserSquareId(String id) {
    userSquareId.value = id;
  }
}
