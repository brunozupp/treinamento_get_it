import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/pages/post/post_list/store/post_list_store.dart';

void main() {

  late PostListStore store;

  setUp(() {
    store = PostListStore();
  });

  test("Should set a list of Posts inside variable 'posts' when the method 'setPosts' is called", () {

    store.setPosts(_posts);

    expect(store.posts.length, equals(3));
    expect(store.posts.isNotEmpty, equals(true));
  });

  test("Should clear the list of variable 'posts' when the method 'clearPosts' is called", () {
    
    store.setPosts(_posts);

    store.clearPosts();

    expect(store.posts.isEmpty, equals(true));
  });

  test("Should set variable 'isLoading' to true when 'setLoading(true)' is called", () {

    store.setLoading(true);

    expect(store.isLoading, equals(true));
  });

  test("Should set variable 'isLoading' to false when 'setLoading(false)' is called", () {

    store.setLoading(false);

    expect(store.isLoading, equals(false));
  });

  test("Should set a object from type RestException inside variable 'error' when 'setError' is called", () {

    store.setError(RestException(
      message: "Message Test", 
      statusCode: 315
    ));

    expect(store.error, allOf(
      isA<RestException>(),
      predicate((RestException error) => error.message == "Message Test" && error.statusCode == 315)
    ));
  });

  test("Should clear the variable error setting it to null", () {

    store.setError(RestException(
      message: "Message Test", 
      statusCode: 315
    ));

    store.clearError();

    expect(store.error, isNull);
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