import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:plates_forward/http_base/exception_handler.dart';
import 'package:plates_forward/http_base/http_base.dart';
import 'package:plates_forward/http_base/constants.dart';
import 'package:plates_forward/square/model/create_order/create_order_request.dart';
import 'package:plates_forward/square/model/create_order/create_order_response.dart';
import 'package:plates_forward/square/model/create_payment/create_payment_request.dart';
import 'package:plates_forward/square/model/create_payment/create_payment_response.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_request.dart';
import 'package:plates_forward/square/model/retrieve_order/retrieve_order_response.dart';

class SquareFunction {
  static const int REQUEST_TIME_OUT = 1;

  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${UrlConstants.token}',
  };

  // Future<dynamic> retrieveOrder({required RetrieveOrderRequest orderId}) async {
  //   http.Response? response;
  //   try {
  //     response = await HttpBase()
  //         .get(
  //             api: UrlConstants.retrieveOrderApi + orderId.orderId,
  //             header: header)
  //         .timeout(const Duration(minutes: REQUEST_TIME_OUT));
  //     debugPrint('error res --> ${response?.body ?? ""}');
  //     return RetrieveOrderResponse.fromJson(json.decode(response?.body ?? ""));
  //   } catch (error) {
  //     return ExceptionHandlers.getExceptionString(
  //         error,
  //         response?.statusCode ?? 0,
  //         UrlConstants.retrieveOrderApi + orderId.orderId);
  //   }
  // }

  Future<dynamic> retrieveOrder({required RetrieveOrderRequest orderId}) async {
    http.Response? response;
    try {
      response = await HttpBase()
          .get(
              api: UrlConstants.retrieveOrderApi + orderId.orderId,
              header: header)
          .timeout(const Duration(minutes: REQUEST_TIME_OUT));
      // debugPrint('res --> ${response?.body ?? ""}');
      // final jsonResponse = json.decode(response?.body ?? "");
     
        // debugPrint('error res --> ${jsonResponse ?? ""}');
        return RetrieveOrderResponse.fromJson(json.decode(response?.body ?? ""));
      
    } catch (error) {
      return ExceptionHandlers.getExceptionString(
          error,
          response?.statusCode ?? 0,
          UrlConstants.retrieveOrderApi + orderId.orderId);
    }
  }

  Future<dynamic> createPayment({required CreatePaymentRequest payment}) async {
    http.Response? response;

    String body = '''
    {
      "idempotency_key": "${payment.idempotencyKey}",
      "source_id": "${payment.sourceId}",
      "accept_partial_authorization": ${payment.acceptPartialAuthorization},
      "amount_money": {
      "amount": ${payment.amountMoney.amount},
      "currency": "${payment.amountMoney.currency}"
      }
    }
    ''';

    try {
      response = await HttpBase()
          .post(api: UrlConstants.createPaymentApi, header: header, body: body)
          .timeout(const Duration(minutes: REQUEST_TIME_OUT));
      debugPrint("");
      debugPrint("");
      debugPrint(response?.body ?? "");
      return CreatePaymentResponse.fromJson(json.decode(response?.body ?? ""));
    } catch (error) {
      return ExceptionHandlers.getExceptionString(
          error, response?.statusCode ?? 0, UrlConstants.createPaymentApi);
    }
  }

  Future<dynamic> createOrder({required CreateOrderRequest createOrder}) async {
    http.Response? response;

    String body = '''
    {
      "idempotency_key": "${createOrder.idempotencyKey}",
      "order": {
      "location_id": "${createOrder.order?.locationId}",
      "customer_id": "${createOrder.order?.customerId}"
      }
    }
    ''';

    try {
      response = await HttpBase()
          .post(api: UrlConstants.createOrderApi, header: header, body: body)
          .timeout(const Duration(minutes: REQUEST_TIME_OUT));
      debugPrint("");
      debugPrint("");
      debugPrint(response?.body ?? "");
      return CreateOrderResponse.fromJson(json.decode(response?.body ?? ""));
    } catch (error) {
      return ExceptionHandlers.getExceptionString(
          error, response?.statusCode ?? 0, UrlConstants.createPaymentApi);
    }
  }
}
