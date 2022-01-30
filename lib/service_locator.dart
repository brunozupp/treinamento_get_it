import 'package:get_it/get_it.dart';
import 'package:treinamento_get_it/pages/post/post_list/store/post_list_store.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';
import 'package:treinamento_get_it/repositories/post_repository.dart';
import 'package:treinamento_get_it/shared/rest_api/rest_api_service.dart';

class ServiceLocator {

  ServiceLocator() {

    GetIt.I.registerSingleton<RestApiService>(RestApiService());

    GetIt.I.registerFactory<IPostRepository>(() => PostRepository(
      restApiService: GetIt.I.get()
    ));

    GetIt.I.registerFactory<PostListStore>(() => PostListStore());
  }
}