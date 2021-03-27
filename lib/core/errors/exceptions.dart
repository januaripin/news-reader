class HttpException implements Exception {
  final int code;
  final String message;

  HttpException({required this.code, required this.message});
}
