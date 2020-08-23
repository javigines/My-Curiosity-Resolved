import 'package:objectbox/objectbox.dart';

final Singleton singletonInstance = new Singleton._privateConstructor();

class Singleton {
  Singleton._privateConstructor();

  Store objectBoxStore;
}
