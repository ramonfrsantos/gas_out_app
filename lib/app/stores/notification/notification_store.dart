import 'package:gas_out_app/data/model/notiification/notification_response_model.dart';
import 'package:gas_out_app/data/repositories/notification/notification_repository.dart';
import 'package:mobx/mobx.dart';
part 'notification_store.g.dart';

class NotificationStore = _NotificationStoreBase with _$NotificationStore;

abstract class _NotificationStoreBase with Store {
  _NotificationStoreBase() {
    getNotifications();
  }

  NotificationRepository _repository = NotificationRepository();

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
