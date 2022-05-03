import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationTiles extends StatelessWidget {
  final String? title;
  final String? body;

  NotificationTiles({
    Key? key, required this.title, required this.body
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/notification.png'), fit: BoxFit.cover)
        ),
      ),
      title: Text(title!, style: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
          color: Colors.black87
      ),),
      subtitle: Text(body!, style: GoogleFonts.roboto(
          color: Colors.black54
      ),),
    );
  }
}