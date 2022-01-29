import 'package:dio/dio.dart';
import 'package:treinamento_get_it/exceptions/rest_exception.dart';
import 'package:treinamento_get_it/models/entities/post.dart';
import 'package:treinamento_get_it/repositories/interfaces/i_post_repository.dart';
import 'package:treinamento_get_it/shared/rest_api/rest_api_service.dart';

class PostRepository implements IPostRepository {
  
  late final RestApiService _restApiService;

  PostRepository({
    required RestApiService restApiService,
  }) {
    _restApiService = restApiService;
  }

  final String _baseUrl = "https://jsonplaceholder.typicode.com/posts";
  
  @override
  Future<List<Post>> getAll() async {
    
    try {
      
      var response = await _restApiService.serviceApi.get(_baseUrl);

      return (response.data as List).map<Post>((e) => Post.fromMap(e)).toList();
      
      // Para testar as exceções
      //return (response.data as List<Map<String,dynamic>>).map<Post>(Post.fromMap).toList();

    } on DioError catch (e) {
      
      if(e.response == null || e.response!.statusCode == null) {
        throw RestException(
          message: "Erro que caiu no DioError - Post", 
          statusCode: 500
        );
      }
      
      // TODO: Verificar as estruturas do Dio sobre status code e sua relação com o estouro de uma exceção DioError
      throw RestException(
        message: "Status code (${e.response!.statusCode}) não corresponde ao esperado (200)", 
        statusCode: e.response!.statusCode!
      );
        
    } catch (e) {
      throw RestException(
        message: "Erro que caiu na Exception Geral - Post", 
        statusCode: 500
      );
    }
  }

  @override
  Future<bool> delete(int id) async {
    
    try {
      
      var response = await _restApiService.serviceApi.delete("$_baseUrl/$id");

      if(response.statusCode != 200) {
        throw RestException(
          message: "Erro que não caiu no DioError e nem na Exception Geral - Post", 
          statusCode: response.statusCode ?? 500
        );
      }

      return true;

    } on DioError catch (e) {

      if(e.response != null && e.response!.statusCode == 404) {
        throw RestException(
          message: "Post não foi encontrado", 
          statusCode: 404
        );
      }

      throw RestException(
        message: "Erro que caiu no DioError - Post", 
        statusCode: e.response?.statusCode ?? 500
      );
    } catch (e) {
      throw RestException(
        message: "Erro que caiu na Exception Geral - Post", 
        statusCode: 500
      );
    }
  }

  @override
  Future<Post> insert(Post post) async {
    
    try {

      var map = post.toMap()..remove("id");
      
      var response = await _restApiService.serviceApi.post(
        _baseUrl,
        data: map
      );

      if(response.statusCode != 201) {
        throw RestException(
          message: "Erro que não caiu no DioError e nem na Exception Geral - Post", 
          statusCode: response.statusCode ?? 500
        );
      }

      return Post.fromMap(response.data);

    } on RestException {
      
      // Por conta que eu estou mandando um throw ali no try, ele não vai cair diretamente onde eu
      // executei a função insert, na verdade ele vai cair aqui mesmo nos 'ONs' e para que eu propague
      // a exceção para onde eu chamei a função eu preciso colocar o RestException na pilha de exceções
      // a serem analisadas e colocar um rethrow para ele mandar para onde a função foi executada. 
      rethrow;

    } on DioError catch (e) {
        throw RestException(
          message: "Erro que caiu no DioError - Post", 
          statusCode: e.response?.statusCode ?? 500
        );
    } catch (e) {
      throw RestException(
        message: "Erro que caiu na Exception Geral - Post", 
        statusCode: 500
      );
    }
  }

  @override
  Future<Post> update(Post post) async {
    
    try {

      var map = post.toMap();
      
      var response = await _restApiService.serviceApi.put(
        "$_baseUrl/${post.id}",
        data: map
      );

      if(response.statusCode != 200) {
        throw RestException(
          message: "Erro que não caiu no DioError e nem na Exception Geral - Post", 
          statusCode: response.statusCode ?? 500
        );
      }

      return Post.fromMap(response.data);

    } on RestException {
      rethrow;
    }
     on DioError catch (e) {
        throw RestException(
          message: "Erro que caiu no DioError - Post", 
          statusCode: e.response?.statusCode ?? 500
        );
    } catch (e) {
      throw RestException(
        message: "Erro que caiu na Exception Geral - Post", 
        statusCode: 500
      );
    }
  }

  @override
  Future<Post> get(int id) async {
    
    try {
      
      var response = await _restApiService.serviceApi.get("$_baseUrl/$id");

      return Post.fromMap(response.data);
      
    } on DioError catch (e) {
      
      if(e.response == null || e.response!.statusCode == null) {
        throw RestException(
          message: "Erro que caiu no DioError - Post", 
          statusCode: 500
        );
      }

      if(e.response!.statusCode == 404) {
        throw RestException(
          message: "Post não foi encontrado", 
          statusCode: e.response!.statusCode!
        );
      }
      
      // TODO: Verificar as estruturas do Dio sobre status code e sua relação com o estouro de uma exceção DioError
      throw RestException(
        message: "Status code (${e.response!.statusCode}) não corresponde ao esperado (200)", 
        statusCode: e.response!.statusCode!
      );
        
    } catch (e) {
      throw RestException(
        message: "Erro que caiu na Exception Geral - Post", 
        statusCode: 500
      );
    }
  }
}
