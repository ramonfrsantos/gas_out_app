import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationTiles extends StatelessWidget {
  final String? title;
  final String? body;
  final String? date;

  NotificationTiles(
      {Key? key, required this.title, required this.body, required this.date})
      : super(key: key);

  DateTime? dateUtc;
  DateTime? dateLocal;

  String? day;
  String? month;
  String? hour;
  String? minute;

  @override
  Widget build(BuildContext context) {
    if (date != null) {
      dateUtc = DateTime.parse(date!);
      dateLocal = dateUtc!.toLocal();

      day = (dateLocal!.day).toString().padLeft(2, '0');
      month = (dateLocal!.month).toString().padLeft(2, '0');
      hour = (dateLocal!.hour).toString().padLeft(2, '0');
      minute = (dateLocal!.minute).toString().padLeft(2, '0');
    }

    return ListTile(
      leading: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/notification.png'),
                fit: BoxFit.cover)),
      ),
      title: Text(
        title!,
        style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      subtitle: Text(
        body! +
            " (" +
            day! +
            "/" +
            month! +
            " às " +
            hour! +
            ":" +
            minute! +
            ")",
        style: GoogleFonts.roboto(color: Colors.black54),
      ),
    );
  }
}
