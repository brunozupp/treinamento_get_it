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
  
  @override
  Future<List<Post>> getAll() async {
    
    try {
      
      var response = await _restApiService.serviceApi.get("https://jsonplaceholder.typicode.com/posts");

      if(response.statusCode != 200) {
        throw RestException(
          message: "Erro que não caiu no DioError e nem na Exception Geral - Post", 
          statusCode: response.statusCode ?? 500
        );
      }

      return (response.data as List).map<Post>((e) => Post.fromMap(e)).toList();

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

  
}
