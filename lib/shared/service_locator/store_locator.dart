import 'package:get_it/get_it.dart';
import 'package:treinamento_get_it/pages/post/post_list/store/post_list_store.dart';

class StoreLocator {

  StoreLocator() {

    GetIt.I.registerFactory<PostListStore>(() => PostListStore());
  }
}