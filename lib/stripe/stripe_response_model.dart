import 'package:plates_forward/models/stripe_model.dart';

class StripeResponseModel {
  final bool isSuccess;
  final String message;
  final StripeModel response;
  StripeResponseModel(
      {required this.isSuccess, required this.message, required this.response});
}
