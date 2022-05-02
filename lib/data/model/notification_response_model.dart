// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationResponseModel notificationResponseModelFromJson(String str) => NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) => json.encode(data.toJson());

class NotificationResponseModel {
  final int? id;
  final DateTime? date;
  final String? message;
  final String? title;

  NotificationResponseModel({
    required this.id,
    required this.date,
    required this.message,
    required this.title
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
    id: json["id"] == null ? null : json["id"],
    date: json["date"] == null ? null : json["date"],
    message: json["message"] == null ? null : json["message"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date": date == null ? null : date,
    "message": message == null ? null : message,
    "title": title == null ? null : title,
  };
}
