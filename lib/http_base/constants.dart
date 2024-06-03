class UrlConstants {
  static const String baseUrl = 'https://connect.squareupsandbox.com';
  static const String retrieveOrderApi = '/v2/orders/';
  static const String createPaymentApi = '/v2/payments';
  static const String createOrderApi = '/v2/orders';

  static const String createUser = '/v2/customers';
  static const String searchUser = '/v2/customers/search';

  static String token = '';
  static const String apiVersion = '2024-03-20';
  static const String orderId = 'pvEaMOXnwki8A9nU0GGMiBOPJe4F';
}

class ExceptionMessage {
  static const String error = 'Error';
  static const String noInternet = 'No internet connection';
  static const String httpError = 'HTTP error occurred';
  static const String dataError = 'Invalid data format';
  static const String timeError = 'Request timeout';
  static const String unknownError = 'Some thing went wrong';
  static const String badError = 'Bad Request';
  static const String forbidError = 'In correct credentials';
  static const String unAutError = 'UnAuthorizedException';
  static const String pagError = 'Page not found';
  static const String userError = 'User not found';
  static const String conflictError = 'Conflict occur';
  static const String fetchError = 'Unable to process the request';
  static const String apiError = 'Api not responding';
  static const String alreadyResponded = 'Already Responded';
  static const String toManyRequests = 'To Many Requests';
}
