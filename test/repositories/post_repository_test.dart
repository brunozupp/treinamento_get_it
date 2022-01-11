import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';
import 'package:treinamento_get_it/repositories/post_repository.dart';
import 'package:treinamento_get_it/shared/rest_api/rest_api_service.dart';

void main() {

  const baseUrl = "https://jsonplaceholder.typicode.com/posts";

  group("Testes unitários do método .getAll()", () {

    late final IPostRepository postRepository;

    final restApiService = RestApiService();

    final dioAdapter = DioAdapter(dio: restApiService.serviceApi);

    setUpAll(() {

      postRepository = PostRepository(
        restApiService: restApiService
      );
    });

    test("Should return a list of Posts when status code is 200", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(200, posts),
      );
      
      var listOfPosts = await postRepository.getAll();

      expect(listOfPosts.isNotEmpty, equals(true));
    });

    test("Should return a empty list of Posts when status code is 200", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(200, []),
      );
      
      var listOfPosts = await postRepository.getAll();

      expect(listOfPosts.isEmpty, equals(true));
    });

    test("Should return a exception of the type RestException when the status code is different from 200", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(432, null),
      );
      
      expect(
        () async => await postRepository.getAll(), 
        throwsA(isA<RestException>())
      );
    });

    test("Should return a exception of the type RestException when the Http Client throws a exception of DioError", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.throws(402, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          )
        )),
      );
      
      
      expect(
        () async => await postRepository.getAll(), 
        throwsA(isA<RestException>())
      );
    });
  });
}

final posts = [
  {
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
    "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  },
  {
    "userId": 1,
    "id": 2,
    "title": "qui est esse",
    "body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
  },
  {
    "userId": 1,
    "id": 3,
    "title": "ea molestias quasi exercitationem repellat qui ipsa sit aut",
    "body": "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut"
  },
  {
    "userId": 1,
    "id": 4,
    "title": "eum et est occaecati",
    "body": "ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit"
  },
  {
    "userId": 1,
    "id": 5,
    "title": "nesciunt quas odio",
    "body": "repudiandae veniam quaerat sunt sed\nalias aut fugiat sit autem sed est\nvoluptatem omnis possimus esse voluptatibus quis\nest aut tenetur dolor neque"
  }
];