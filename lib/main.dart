import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:treinamento_get_it/my_app.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';
import 'package:treinamento_get_it/repositories/post_repository.dart';
import 'package:treinamento_get_it/service_locator.dart';
import 'package:treinamento_get_it/shared/rest_api/rest_api_service.dart';

void main() {

  ServiceLocator();

  runApp(const MyApp());
}

// void setup() {

//   GetIt.I.registerSingleton<RestApiService>(RestApiService());

//   GetIt.I.registerFactory<IPostRepository>(() => PostRepository(
//     restApiService: GetIt.I.get<RestApiService>()
//   ));
// }