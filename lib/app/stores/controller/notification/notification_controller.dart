import 'package:gas_out_app/data/model/notiification/notification_response_model.dart';
import 'package:gas_out_app/data/repositories/notification/notification_repository.dart';
import 'package:mobx/mobx.dart';
part 'notification_controller.g.dart';

class NotificationController = _NotificationControllerBase with _$NotificationController;

abstract class _NotificationControllerBase with Store {
  _NotificationControllerBase(String login) {
    getUserNotifications(login);
  }

  NotificationRepository _repository = NotificationRepository();

  @observable
  List<NotificationResponseModel>? notificationList;

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
