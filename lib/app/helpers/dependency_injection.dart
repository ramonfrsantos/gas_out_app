import 'package:get_it/get_it.dart';

import '../stores/detailpage_store.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<DetailPageStore>(() => DetailPageStore());
}
