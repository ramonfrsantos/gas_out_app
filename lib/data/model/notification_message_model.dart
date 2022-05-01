// To parse this JSON data, do
//
//     final notificationMessageModel = notificationMessageModelFromJson(jsonString);

import 'dart:convert';

NotificationMessageModel notificationMessageModelFromJson(String str) => NotificationMessageModel.fromJson(json.decode(str));

String notificationMessageModelToJson(NotificationMessageModel data) => json.encode(data.toJson());

class NotificationMessageModel {
  NotificationMessageModel({
    required this.message
  });

  final String? message;

  factory NotificationMessageModel.fromJson(Map<String, dynamic> json) => NotificationMessageModel(
    message: json["message"] == null ? null : json["message"]
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
  };
}
