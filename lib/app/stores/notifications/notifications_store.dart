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
  List<NotificationResponseModel>? notificationList;

  @action
  getNotifications() async {
    notificationList = await _repository.getNotifications();
    print(notificationList);
  }

  @action
  deleteNotification(int id) async {
    await _repository.deleteNotification(id);
  }
}
