import 'package:get_it/get_it.dart';
import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';

class ControllerLocator {

  ControllerLocator() {

    GetIt.I.registerFactory<PostListController>(() => PostListController(
      postListStore: GetIt.I.get(),
      postRepository: GetIt.I.get(),
    ));
  }
}