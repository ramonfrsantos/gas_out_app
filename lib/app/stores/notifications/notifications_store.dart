import 'package:gas_out_app/data/model/notification_response_model.dart';
import 'package:gas_out_app/data/repositories/notifications_repository.dart';
import 'package:mobx/mobx.dart';
part 'notifications_store.g.dart';

class NotificationsStore = _NotificationsStoreBase with _$NotificationsStore;

abstract class _NotificationsStoreBase with Store {
  _NotificationsStoreBase() {
    getNotifications();
  }

  NotificationsRepository _repository = NotificationsRepository();

  @observable
  List<NotificationResponseModel>? model;

  @action
  getNotifications() async {
    model = await _repository.getNotifications();
    print(model);
  }
}
