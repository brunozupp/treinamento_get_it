import 'package:get_it/get_it.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';
import 'package:treinamento_get_it/repositories/post_repository.dart';
import 'package:treinamento_get_it/shared/rest_api/rest_api_service.dart';

class RepositoryLocator {

  RepositoryLocator() {

    GetIt.I.registerSingleton<RestApiService>(RestApiService());

    GetIt.I.registerFactory<IPostRepository>(() => PostRepository(
      restApiService: GetIt.I.get()
    ));
  }
}