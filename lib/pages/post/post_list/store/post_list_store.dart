import 'package:mobx/mobx.dart';
import 'package:treinamento_get_it/exceptions/base_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
part 'post_list_store.g.dart';

class PostListStore = _PostListStoreBase with _$PostListStore;

abstract class _PostListStoreBase with Store {
  
  @observable
  ObservableList<Post> posts = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @observable
  BaseException? error;

  @action 
  void setPosts(List<Post> value) {
    posts.addAll(value);
  }

  @action
  void clearPosts() {
    posts.clear();
  }

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setError(BaseException value) {
    error = value;
  }

  @action
  void clearError() {
    error = null;
  }

}