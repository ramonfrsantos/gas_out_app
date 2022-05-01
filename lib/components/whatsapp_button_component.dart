import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WhatsAppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String message = "Olá, gostaria de falar com o suporte.";
    String phone = "+5531996676802"; // telefone do suporte

    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(220, 105, 35, 1.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )
            )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SUPORTE',
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Image.asset(
              "images/icWhatsApp.png",
              color: Colors.white,
              width: 26,
              height: 26,
            )
          ],
        ),
        onPressed: () {
          String url = 'whatsapp://send?phone=$phone&text=$message';

          launchUrlString(url);
        },
      ),
    );
  }
}
