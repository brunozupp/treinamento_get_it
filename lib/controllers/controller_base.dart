import 'package:mobx/mobx.dart';

abstract class ControllerBase<T extends Store> {

  T get store;
}