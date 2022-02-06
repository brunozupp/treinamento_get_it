import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';

import '../../mocks/repositories/mock_repositories.mocks.dart';
import '../../mocks/stores/mock_stores.mocks.dart';

void main() {

  late final IPostRepository repository;
  late PostListController controller;

  setUpAll(() {
    repository = MockPostRepository();
  });

  group("Unit test from method .getAll() using a Mocked Store", () {

    setUp(() {
      controller = PostListController(
        postListStore: MockPostListStore(),
        postRepository: repository
      );
    });

    /**
     * IMPORTANTE
     * Note: When mockito verifies a method call, said call is then excluded 
     * from further verifications. A single method call cannot be verified from 
     * multiple calls to verify, or verifyInOrder
     * 
     * Por isso que separei em dois testes diferentes, um verificando a quantidade
     * de chamadas feitas e outro verificando a ordem
     */

    test("Should execute all methods inside controller.getAll() in exactly the number of times expected when the response to repository is successful", () async {
      
      when(repository.getAll()).thenAnswer((_) async => _posts);
     
      await controller.getAll();
      
      verify(controller.store.setLoading(true)).called(1);
      verify(controller.store.clearError()).called(1);
      verify(repository.getAll()).called(1);
      verify(controller.store.clearPosts()).called(1);
      verify(controller.store.setPosts(_posts)).called(1);
      verify(controller.store.setLoading(false)).called(1);
    });

    test("Should verify the correct order of executed methods insede method controller.getAll() when the response to repository is successful", () async {
      
      when(repository.getAll()).thenAnswer((_) async => _posts);
     
      await controller.getAll();

      verifyInOrder([
        controller.store.setLoading(true),
        controller.store.clearError(),
        repository.getAll(),
        controller.store.clearPosts(),
        controller.store.setPosts(_posts),
        controller.store.setLoading(false)
      ]);
    });

    test("Should execute all methods inside controller.getAll() in exactly the number of times expected when the response to repository is a failuree", () async {
      
      var exception = RestException(
        message: "Erro", 
        statusCode: 345
      );

      when(repository.getAll()).thenThrow(exception);

      await controller.getAll();

      verify(controller.store.setLoading(true)).called(1);
      verify(controller.store.clearError()).called(1);
      verify(repository.getAll()).called(1);
      verify(controller.store.setError(exception)).called(1);
      verify(controller.store.setLoading(false)).called(1);
    });

    test("Should verify the correct order of executed methods insede controller.getAll() when the response to repository is a failure", () async {
      
      var exception = RestException(
        message: "Erro", 
        statusCode: 345
      );

      when(repository.getAll()).thenThrow(exception);
     
      await controller.getAll();

      verifyInOrder([
        controller.store.setLoading(true),
        controller.store.clearError(),
        repository.getAll(),
        controller.store.setError(exception),
        controller.store.setLoading(false)
      ]);
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