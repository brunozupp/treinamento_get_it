import 'package:treinamento_get_it/models/entities/post.dart';

abstract class IPostRepository {

  Future<List<Post>> getAll();
}