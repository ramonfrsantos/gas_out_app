import '../../app/screens/contact_screen.dart';
import '../../app/screens/home_screen.dart';
import '../../app/screens/notifications_screen.dart';
import '../../app/screens/stats_screen.dart';

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