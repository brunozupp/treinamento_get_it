import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';
import 'package:treinamento_get_it/repositories/post_repository.dart';
import 'package:treinamento_get_it/shared/rest_api/rest_api_service.dart';

void main() {

  const baseUrl = "https://jsonplaceholder.typicode.com/posts";

  late final IPostRepository postRepository;

  final restApiService = RestApiService();

  final dioAdapter = DioAdapter(dio: restApiService.serviceApi);

  setUpAll(() {

    postRepository = PostRepository(
      restApiService: restApiService
    );
  });

  group("Unit tests from method .getAll()", () {

    test("Should return a list of Posts when status code is 200", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(200, postsMap),
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

    test("Should return a exception of the type RestException with the message 'Status code (432) não corresponde ao esperado (200)'", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(432, null),
      );

      expect(
        () async => await postRepository.getAll(), 
        throwsA(
          predicate((error) => error is RestException && error.message == "Status code (432) não corresponde ao esperado (200)")
        )
      );
    });

    test("Should return a exception of the type RestException with the status code 432'", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(432, null),
      );

      expect(
        () async => await postRepository.getAll(), 
        throwsA(
          predicate((error) => error is RestException && error.statusCode == 432)
        )
      );
    });

    test("Should return a exception of the type RestException with the message 'Status code (432) não corresponde ao esperado (200)' and status code 432", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(432, null),
      );

      expect(
        () async => await postRepository.getAll(), 
        throwsA(
          allOf([
            isA<RestException>(),
            predicate((RestException error) => error.message == "Status code (432) não corresponde ao esperado (200)"),
            predicate((error) => error is RestException && error.statusCode == 432)
          ])
        )
      );
    });

    test("Should return a exception of the type RestException when the Http Client throws a exception of DioError", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.throws(432, DioError(
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

    test("Should return a exception of the type RestException with the message 'Status code (432) não corresponde ao esperado (200)' and status code 432 when the Http Client throws a exception of DioError", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.throws(432, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: baseUrl
            ),
            statusCode: 432
          ),
        )),
      );
      
      expect(
        () async => await postRepository.getAll(), 
        throwsA(allOf([
          isA<RestException>(),
          predicate((RestException error) => error.message == "Status code (432) não corresponde ao esperado (200)"),
          predicate((error) => error is RestException && error.statusCode == 432)
        ]))
      );
    });

    test("Should return a exception of the type RestException with the message 'Erro que caiu no DioError - Post' and status code 500 when Response is null", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.throws(432, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          ),
          response: null
        )),
      );
      
      expect(
        () async => await postRepository.getAll(), 
        throwsA(
          predicate(
            (error) => error is RestException && error.message == "Erro que caiu no DioError - Post" && error.statusCode == 500
          )
        )
      );
    });

    test("Should return a exception of the type RestException with the message 'Erro que caiu no DioError - Post' and statis code 500 when the Response is not null and status code is null", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.throws(432, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: baseUrl
            ),
            statusCode: null
          ),
        )),
      );
      
      expect(
        () async => await postRepository.getAll(), 
        throwsA(
          predicate(
            (error) => error is RestException && error.message == "Erro que caiu no DioError - Post" && error.statusCode == 500
          )
        )
      );
    });

    test("Should return a exception of the type RestException with the message 'Erro que caiu na Exception Geral - Post' and status code 500 when is thrown a General Exception during the .fromMap()", () async {

      dioAdapter.onGet(
        baseUrl,
        (server) => server.reply(200, [
          {
            "id": "fake"
          }
        ]),
      );
      
      expect(
        () async => await postRepository.getAll(), 
        throwsA(allOf([
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que caiu na Exception Geral - Post"),
          predicate((error) => error is RestException && error.statusCode == 500)
        ]))
      );
    });

  });

  group("Unit tests from method .get(id)", () {

    test("Should return a object of type Post when status code from response is 200", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(200, postsMap.where((element) => element["id"] == id).first),
      );

      final post = await postRepository.get(id);

      expect(post, isA<Post>());

    });

    test("Should return a Post object with id 1 when status code from response is 200", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(200, postsMap.where((element) => element["id"] == id).first),
      );

      final post = await postRepository.get(id);

      expect(post.id, equals(id));

    });

    test("Should return a object of type Post and with id 1 when status code from response is 200", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(200, postsMap.where((element) => element["id"] == id).first),
      );

      final post = await postRepository.get(id);

      expect(post, allOf([
        isA<Post>(),
        predicate((Post post) => post.id == id)
      ]));

    });

    test("Should return a Exception of type RestException when status code from response is 404", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(404, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(isA<RestException>())
      );
    });

    test("Should return a RestException with message 'Post não foi encontrado' when status code from response is 404", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(404, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(
          predicate((RestException error) => error.message == 'Post não foi encontrado')
        )
      );
    });

    test("Should return a RestException with status code 404 when status code from response is 404", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(404, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(
          predicate((RestException error) => error.statusCode == 404)
        )
      );
    });

    test("Should return a Exception of type RestException with status code 404 and message 'Post não foi encontrado' when status code from response is 404", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(404, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(
          allOf([
            isA<RestException>(),
            predicate((RestException error) => error.message == 'Post não foi encontrado'),
            predicate((RestException error) => error.statusCode == 404)
          ])
        )
      );
    });

    test("Should return a Exception of type RestException when status code from response is different from 2xx", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(345, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(isA<RestException>())
      );
    });

    test("Should return a RestException with status code 345 when status code from response is 345", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(345, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(
          predicate((RestException error) => error.statusCode == 345)
        )
      );
    });

    test("Should return a RestException with message 'Status code (345) não corresponde ao esperado (200)' when status code from response is 345", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(345, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(
          predicate((RestException error) => error.message == 'Status code (345) não corresponde ao esperado (200)')
        )
      );
    });

    test("Should return a Exception of type RestException with message 'Status code (345) não corresponde ao esperado (200)' and status code 345 when status code from response is 345", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(345, {}),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(
          allOf(
            isA<RestException>(),
            predicate((RestException error) => error.message == 'Status code (345) não corresponde ao esperado (200)'),
            predicate((RestException error) => error.statusCode == 345),
          )
        )
      );
    });

    test("Should return a RestException when a DioError without a Response is thrown", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.throws(345, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          )
        )),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(isA<RestException>())
      );
    });

    test("Should return a RestException with message 'Erro que caiu no DioError - Post' and status code 500 when a DioError without a Response is thrown", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.throws(345, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          )
        )),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(allOf(
          predicate((RestException error) => error.message == "Erro que caiu no DioError - Post"),
          predicate((RestException error) => error.statusCode == 500),
        ))
      );
    });

    test("Should return a RestException when a DioError with a Response without a status code is thrown", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.throws(345, DioError(
          requestOptions: RequestOptions(
            path: baseUrl,
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: baseUrl,
            ),
          ),
        )),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(isA<RestException>())
      );
    });

    test("Should return a RestException with message 'Erro que caiu no DioError - Post' and status code 500 when a DioError with a Response without status code is thrown", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.throws(345, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: baseUrl,
            ),
          ),
        )),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(allOf(
          predicate((RestException error) => error.message == "Erro que caiu no DioError - Post"),
          predicate((RestException error) => error.statusCode == 500),
        ))
      );
    });

    test("Should return a RestException with message 'Erro que caiu na Exception Geral - Post' and status code 500 when a General Exception is thrown during .fromMap()", () async {

      const id = 1;

      dioAdapter.onGet(
        baseUrl + "/$id",
        (server) => server.reply(200, {
          "id": "fake",
        }),
      );

      expect(
        () async => await postRepository.get(id), 
        throwsA(allOf(
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que caiu na Exception Geral - Post"),
          predicate((RestException error) => error.statusCode == 500),
        ))
      );
    });
    
  });

  group("Unit tests from method .insert(Post post)", () {

    test("Should insert a new Post and return the Post with a autogenerated Id and the same fields when status code from response is 201", () async {

      final Post post = postsModel.first;

      // O objeto que é enviado para o post tem que ser exatamente igual, por isso eu remove aqui o id e não faço post.copyWith(id: 0).toMap
      // diretamente no data do onPost, pois isso resultaria em erro já que ele possui o atributo id e no método do repositório eu tiro esse
      // atributo para enviar
      var map = post.toMap()..remove("id");

      dioAdapter.onPost(
        baseUrl, 
        (server) => server.reply(201, post.toMap()),
        data: map,
      );

      var newPost = await postRepository.insert(post);

      expect(newPost, equals(post));
    });

    test("Should return a Exception from the type RestException with the message 'Erro que não caiu no DioError e nem na Exception Geral - Post' and status code 232 when the status code from Response is in the range of 2xx and different than 201", () {

      final Post post = postsModel.first;

      var map = post.toMap()..remove("id");

      dioAdapter.onPost(
        baseUrl, 
        (server) => server.reply(232, post.toMap()),
        data: map,
      );

      expect(
        () async => await postRepository.insert(post), 
        throwsA(allOf(
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que não caiu no DioError e nem na Exception Geral - Post"),
          predicate((RestException error) => error.statusCode == 232),
        ))
      );

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 345 when the status code from Response is different from de range of 2xx", () {

      final Post post = postsModel.first;

      var map = post.toMap()..remove("id");

      dioAdapter.onPost(
        baseUrl, 
        (server) => server.reply(345, post.toMap()),
        data: map,
      );

      expect(
        () async => await postRepository.insert(post), 
        throwsA(allOf(
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que caiu no DioError - Post"),
          predicate((RestException error) => error.statusCode == 345),
        ))
      );
    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 500 when thrown a DioError exception without status code", () {

      final Post post = postsModel.first;

      var map = post.toMap()..remove("id");

      dioAdapter.onPost(
        baseUrl, 
        (server) => server.throws(500, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          ),
        )),
        data: map,
      );

      expect(
        () async => await postRepository.insert(post), 
        throwsA(allOf(
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que caiu no DioError - Post"),
          predicate((RestException error) => error.statusCode == 500)
        )),
      );
    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 345 when thrown a DioError exception with status code 345", () {

      final Post post = postsModel.first;

      var map = post.toMap()..remove("id");

      dioAdapter.onPost(
        baseUrl, 
        (server) => server.throws(345, DioError(
          requestOptions: RequestOptions(
            path: baseUrl
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: baseUrl
            ),
            statusCode: 345
          )
        )),
        data: map,
      );

      expect(
        () async => await postRepository.insert(post), 
        throwsA(allOf(
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que caiu no DioError - Post"),
          predicate((RestException error) => error.statusCode == 345)
        )),
      );
    });

    test("Should returna a Exception from type RestException with the message 'Erro que caiu na Exception Geral - Post' and status code 500 when the data from response is not what is expected in Post.fromMap", () {

      final Post post = postsModel.first;

      var map = post.toMap()..remove("id");

      dioAdapter.onPost(
        baseUrl, 
        (server) => server.reply(201, {
          "fake": 1
        }),
        data: map,
      );

      expect(
        () async => await postRepository.insert(post), 
        throwsA(allOf(
          isA<RestException>(),
          predicate((RestException error) => error.message == "Erro que caiu na Exception Geral - Post"),
          predicate((RestException error) => error.statusCode == 500)
        )),
      );
    });
  });
  
  // O id que vai pegar é da url, se for diferente ambos, o que vai persistir é o id da url
  group("Unit tests from method .update(Post post)", () {

    test("Should update a new Post and return the Post with all the fields updated when status code from response is 200", () {

    });

    test("Should return a Exception from the type RestException with the message 'Erro que não caiu no DioError e nem na Exception Geral - Post' and status code 232 when the status code from Response is in the range of 2xx and different than 200", () {

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 345 when the status code from Response is different from de range of 2xx", () {

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 500 when thrown a DioError exception without status code", () {

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 345 when thrown a DioError exception with status code 345", () {

    });

    test("Should returna a Exception from type RestException with the message 'Erro que caiu na Exception Geral - Post' and status code 500 when the data from response is not what is expected in Post.fromMap", () {

    });
  });

  group("Unit tests from method .delete(int id)", () {

    test("Should return true when status code from Response is 200", () {

    });

    test("Should return a Exception from the type RestException with the message 'Erro que não caiu no DioError e nem na Exception Geral - Post' and status code 232 when the status code from Response is in the range of 2xx and different than 200", () {

    });

    test("Should return a Exception from the type RestException with the message 'Post não foi encontrado' and status code 404 when the status code from Response is 404", () {

    });

    test("Should return a Exception from the type RestException with the message 'Post não foi encontrado' and status code 404 when not passed the id in url by throwing a exception with code 404", () {

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 345 when the status code from Response is different from de range of 2xx", () {

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 500 when thrown a DioError exception without status code", () {

    });

    test("Should return a Exception from type RestException with the message 'Erro que caiu no DioError - Post' and status code 345 when thrown a DioError exception with status code 345", () {

    });

    test("Should returna a Exception from type RestException with the message 'Erro que caiu na Exception Geral - Post' and status code 500 when the data from response is not what is expected in Post.fromMap", () {

    });
  });
}

final List<Map<String, dynamic>> postsMap = <Map<String, dynamic>>[
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

final List<Post> postsModel = postsMap.map(Post.fromMap).toList();