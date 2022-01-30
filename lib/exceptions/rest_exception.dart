import 'package:treinamento_get_it/exceptions/base_exception.dart';

class RestException extends BaseException {

  final int statusCode;
  
  RestException({
    required String message,
    required this.statusCode,
  }) : super(message: message);
}
