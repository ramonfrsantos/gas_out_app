import '../screens/notifications.dart';
import '../screens/home.dart';
import '../screens/contact.dart';
import '../screens/stats.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerClasses() {
    register<Home>(() => Home());
    register<Notifications>(() => Notifications());
    register<Stats>(() => Stats());
    register<Contact>(() => Contact());
  }

  static dynamic fromString(String type) {
      return _constructors[type]!();
  }
}