import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/pages/post/stores/post_list_store/post_list_store.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';

class PostListController {

  final IPostRepository _postRepository;
  final PostListStore _postListStore;

  PostListController({
    required IPostRepository postRepository,
    required PostListStore postListStore,
  }) :
  _postRepository = postRepository,
  _postListStore = postListStore;

  PostListStore get store => _postListStore;

  Future<void> getAll() async {

    _postListStore.setLoading(true);

    try {

      var posts = await _postRepository.getAll();
      
      _postListStore.clearPosts();
      _postListStore.setPosts(posts);

    } on RestException catch (e) {
      _postListStore.setError(e.message);
    } finally {
      _postListStore.setLoading(false);
    }
  }
}
