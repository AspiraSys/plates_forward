import 'package:get/get.dart';

class UserController extends GetxController {
  var userSquareId = ''.obs;

  void setUserSquareId(String id) {
    userSquareId.value = id;
  }
}

class NameController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;

  // A method to set user details
  void setUserDetails({required String firstName, required String lastName}) {
    this.firstName.value = firstName;
    this.lastName.value = lastName;
  }
}
