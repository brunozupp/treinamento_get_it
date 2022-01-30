import 'package:treinamento_get_it/shared/service_locator/controller_locator.dart';
import 'package:treinamento_get_it/shared/service_locator/repository_locator.dart';
import 'package:treinamento_get_it/shared/service_locator/store_locator.dart';

class ServiceLocator {

  ServiceLocator() {

    RepositoryLocator();
    StoreLocator();
    ControllerLocator();
  }
}