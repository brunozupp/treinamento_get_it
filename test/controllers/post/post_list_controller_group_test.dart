import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:treinamento_get_it/controllers/post/post_list_controller.dart';
import 'package:treinamento_get_it/exceptions/base_exception.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/pages/post/post_list/store/post_list_store.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';

import '../../mocks/repositories/mock_repositories.mocks.dart';
import '../../mocks/stores/mock_stores.mocks.dart';

void main() {

  late IPostRepository repository;
  late PostListController controller;

  // Não mais inicializando esse cara aqui e retirando o final do repository pois
  // pois precisar inicializar ele em cada grupo, para evitar o erro de contagem
  // na execução do primeiro método do segundo grupo, que dá a contagem de getAll
  // como sendo 2. Fazendo esse ajuste a contagem fica 1 que é o certo
  // setUpAll(() {
  //   repository = MockPostRepository();
  // });

  group("Unit test from method .getAll() using a real store", () {

    setUpAll(() {
      repository = MockPostRepository();
    });

    setUp(() {
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

  group("Unit test from method .getAll() using a Mocked Store", () {

    setUpAll(() {
      repository = MockPostRepository();
    });

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