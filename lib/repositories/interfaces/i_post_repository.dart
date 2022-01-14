import 'package:treinamento_get_it/models/entities/post.dart';

abstract class IPostRepository {

  Future<List<Post>> getAll();

  Future<Post> get(int id);

  Future<Post> insert(Post post);

  Future<Post> update(Post post);

  Future<bool> delete(int id);
}