import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';
import 'package:treinamento_get_it/exceptions/base_exception.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/pages/post/post_list/store/post_list_store.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';

import '../../mocks/repositories/mock_repositories.mocks.dart';

void main() {

  late IPostRepository repository;
  late PostListController controller;

  group("Unit test from method .getAll()", () {

    setUp(() {

      repository = MockPostRepository();

      controller = PostListController(
        postListStore: PostListStore(),
        postRepository: repository
      );
    });

    test("Should set a list of posts when the request is successful, returning a list of posts", () async {
      
      when(repository.getAll()).thenAnswer((_) async => _posts);

      await controller.getAll();

      verify(repository.getAll()).called(1);
      expect(controller.store.posts, isNotEmpty);
      expect(controller.store.posts.length, equals(3));
    });

    test("Should set a empty list of posts when the request is successful, returning a empty list", () async {

      when(repository.getAll()).thenAnswer((_) async => []);

      await controller.getAll();

      verify(repository.getAll()).called(1);
      expect(controller.store.posts, isEmpty);
      expect(controller.store.posts.length, equals(0));
    });

    test("Should set the exception in variable 'error' from store when an exception is thrown", () async {
      
      when(repository.getAll()).thenThrow(RestException(
        message: "Erro", 
        statusCode: 345
      ));

      await controller.getAll();

      expect(controller.store.error, isNotNull);
      expect(controller.store.error, predicate(
        (BaseException error) => error is RestException && error.message == "Erro" && error.statusCode == 345
      ));
    });
  }); 
}

final _posts = [
  Post(
    userId: 1, id: 1, title: "Titulo 1", body: "Conteudo 1"
  ),
  Post(
    userId: 1, id: 2, title: "Titulo 2", body: "Conteudo 2"
  ),
  Post(
    userId: 1, id: 3, title: "Titulo 3", body: "Conteudo 3"
  ),
];