import 'dart:async';
import 'dart:io';

import 'package:plates_forward/http_base/constants.dart';
import 'package:plates_forward/http_base/exception.dart';

class ExceptionHandlers {
  static getExceptionString(error, int code, String url) {
    if (error is SocketException) {
      return AppException(
          code: code, message: ExceptionMessage.noInternet, url: url);
    } else if (error is HttpException) {
      return AppException(
          code: code, message: ExceptionMessage.httpError, url: url);
    } else if (error is FormatException) {
      return AppException(
          code: code, message: ExceptionMessage.dataError, url: url);
    } else if (error is TimeoutException) {
      return AppException(
          code: code, message: ExceptionMessage.timeError, url: url);
    } else {
      return AppException(
          code: code, message: ExceptionMessage.unknownError, url: url);
    }
  }
}
