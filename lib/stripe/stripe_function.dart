import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:plates_forward/models/stripe_model.dart';
import 'package:plates_forward/stripe/stripe_response_model.dart';
import 'package:plates_forward/models/secret_key.dart';

class StripePayment {
  Map<String, dynamic>? paymentIntent;
  int amount = 0;
  bool isOpened = false;
  StripeModel stripeModel = StripeModel();
  final StripeKeys stripeKeys;

StripePayment({required this.stripeKeys});
  Future<StripeResponseModel> stripeMakePayment(
      {required String amount, required String currency}) async {
          print('in api ${stripeKeys.secretKey}');

    try {
      paymentIntent = await createPaymentIntent(amount, currency);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: const BillingDetails(
                name: 'YOUR NAME',
                email: 'YOUREMAIL@gmail.com',
                phone: 'YOUR NUMBER',
                address: Address(
                    city: 'YOUR CITY',
                    country: 'YOUR COUNTRY',
                    line1: 'YOUR ADDRESS 1',
                    line2: 'YOUR ADDRESS 2',
                    postalCode: 'YOUR PINCODE',
                    state: 'YOUR STATE')),
            paymentIntentClientSecret:
                paymentIntent!['client_secret'], //Gotten from payment intent
            customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
            customerId: paymentIntent!['id'],
            merchantDisplayName: 'PlateItForward',
            // style: ThemeMode.dark,
          ))
          .then((value) {});

      return displayPaymentSheet();
    } catch (e) {
      return StripeResponseModel(
          isSuccess: false, message: e.toString(), response: stripeModel);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          // 'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Authorization': 'Bearer ${stripeKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      debugPrint("--> ${json.decode(response.body).toString()}");

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String transactionId = responseData['id'];
        double totalAmount = (responseData['amount'] ?? 0) / 100;
        String currency = responseData['currency'];
        String paymentMethodTypes = responseData['payment_method_types'][0];
        String status = responseData['status'];

        stripeModel = StripeModel(
          transactionId: transactionId,
          totalAmount: totalAmount,
          currency: currency,
          payment_method_types: paymentMethodTypes,
          status: status,
          paymentProcess: false,
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception(
            'Failed to create payment intent: ${response.statusCode}');
      }
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<StripeResponseModel> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      debugPrint('Payment successfully completed');
      stripeModel.paymentProcess = true;
      stripeModel.status = "Completed";
      return StripeResponseModel(
          isSuccess: true,
          message: 'Payment successfully completed',
          response: stripeModel);
    } on Exception catch (e) {
      if (e is StripeException) {
        debugPrint('Error from Stripe: ${e.error.localizedMessage}');
        stripeModel.paymentProcess = false;
        stripeModel.status = "Payment Failed";
        return StripeResponseModel(
            isSuccess: false,
            message: e.error.message.toString(),
            response: stripeModel);
      } else {
        debugPrint('Unforeseen error: $e');
        stripeModel.paymentProcess = false;
        stripeModel.status = "Error";
        return StripeResponseModel(
            isSuccess: false, message: e.toString(), response: stripeModel);
      }
    }
  }
}
