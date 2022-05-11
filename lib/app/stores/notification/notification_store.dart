import 'package:gas_out_app/data/model/notiification/notification_response_model.dart';
import 'package:gas_out_app/data/repositories/notification/notification_repository.dart';
import 'package:mobx/mobx.dart';
part 'notification_store.g.dart';

class NotificationStore = _NotificationStoreBase with _$NotificationStore;

abstract class _NotificationStoreBase with Store {
  _NotificationStoreBase(String login) {
    getUserNotifications(login);
  }

  NotificationRepository _repository = NotificationRepository();

  @observable
  List<NotificationResponseModel>? notificationList;

  //@action
  //getAllNotifications() async {
  // notificationList = await _repository.getAllNotifications();
  // print(notificationList);
  //}

  @action
  getUserNotifications(String login) async {
    notificationList = await _repository.getUserNotifications(login);
    print(notificationList);
  }

  @action
  deleteNotification(int id, String email) async {
    await _repository.deleteNotification(id, email);
  }
}
