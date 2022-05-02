class NotificationDTO {
  final int id;
  final DateTime date;
  final String message;
  final String title;

  const NotificationDTO({
    required this.id,
    required this.date,
    required this.message,
    required this.title,
  });

  static NotificationDTO fromJson(json) => NotificationDTO(
      id: json['id'],
      date: json['date'],
      message: json['message'],
      title: json['title']
  );
}