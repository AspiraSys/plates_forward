import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:plates_forward/stripe/stripe_response_model.dart';

class StripePayment {

  Map<String, dynamic>? paymentIntent;
  int amount = 0;
  bool isOpened = false;

  Future<StripeResponseModel> stripeMakePayment({required String amount, required String currency}) async {
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
              paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
              customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
              customerId: paymentIntent!['id'],
              merchantDisplayName: 'PlateItForward',
              style: ThemeMode.dark,
          ))
          .then((value) {
      });

      return displayPaymentSheet();
    } catch (e) {
      return StripeResponseModel(isSuccess: false,message: e.toString());
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
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      debugPrint("--> ${json.decode(response.body).toString()}");
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<StripeResponseModel>displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      debugPrint( 'Payment successfully completed');
      return StripeResponseModel(isSuccess: true,message: 'Payment successfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
          debugPrint('Error from Stripe: ${e.error.localizedMessage}');
          return StripeResponseModel(isSuccess: false,message: e.error.message.toString());
      } else {
        debugPrint('Unforeseen error: $e');
        return StripeResponseModel(isSuccess: false,message: e.toString());
      }
    }
  }
}