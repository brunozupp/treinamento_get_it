import 'package:dio/dio.dart';

class RestApiService {

  late final Dio _serviceApi;

  RestApiService() {
    _serviceApi = Dio();
  }

  Dio get serviceApi => _serviceApi; 
}