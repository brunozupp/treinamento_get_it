class RestException implements Exception {

  final String message;
  final int statusCode;
  
  RestException({
    required this.message,
    required this.statusCode,
  });
}
