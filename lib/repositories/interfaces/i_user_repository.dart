import 'package:treinamento_get_it/models/entities/user.dart';

abstract class IUserRepository {

  Future<List<User>> getAll();

  Future<User> insert(User user);

  Future<User> update(User user);

  Future<bool> delete(int id);
}