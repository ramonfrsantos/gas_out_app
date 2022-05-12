import '../../app/screens/home/home_screen.dart';
import '../../app/screens/notification/notification_screen.dart';
import '../../app/screens/stats/stats_screen.dart';
import '../../main_dev.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerStats() {
    register<StatsScreen>(() => StatsScreen());
  }

  static void registerHome(String? username) {
    register<HomeScreen>(() => HomeScreen(username: username,));
  }

  static void registerNotification(String? email) {
    register<NotificationScreen>(() => NotificationScreen(email: email));
  }

  static dynamic fromString(String type) {
      return _constructors[type]!();
  }
}