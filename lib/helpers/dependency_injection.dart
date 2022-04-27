import 'package:gas_out_app/stores/detailpage_store.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<DetailPageStore>(() => DetailPageStore());
}
