import 'package:gas_out_app/app/stores/detail_page/detailpage_store.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<DetailPageStore>(() => DetailPageStore());
}
