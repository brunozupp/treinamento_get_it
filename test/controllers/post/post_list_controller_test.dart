import 'package:flutter_test/flutter_test.dart';
import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';
import 'package:treinamento_get_it/pages/post/post_list/store/post_list_store.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';

import '../../mocks/repositories/mock_repositories.mocks.dart';

void main() {

  late final IPostRepository repository;
  late PostListController controller;
  late PostListStore store;

  setUpAll(() {
    repository = MockPostRepository();
  });

  group("Unit test from method .getAll()", () {

    setUp(() {
      controller = PostListController(
        postListStore: PostListStore(),
        postRepository: repository
      );
    });

    test("Should set a list of posts when the request is successful, returning a list of posts", () async {
      
    });

    test("Should set a empty list of posts when the request is successful, returning a empty list", () async {

    });

    test("Should set the exception in variable 'error' from store when an exception is thrown", () async {

    });
  });

  
}