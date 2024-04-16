class AppException implements Exception {
  final String message;
  final int code;
  final String url;
  AppException({required this.code,required this.message,required this.url});
}