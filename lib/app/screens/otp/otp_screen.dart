import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_out_app/app/constants/gasout_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.verificationCode, required this.email}) : super(key: key);
  final String? verificationCode;
  final String? email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                  )
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SvgPicture.asset(
                            "images/otp.svg",
                          height: 180,
                          width: 180,
                          color: ConstantColors.primaryColor,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Código de verificação",
                          style: GoogleFonts.muli(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RichText(text: TextSpan(
                          text: "Enviado para ",
                          style: GoogleFonts.muli(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 15.5
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.email,
                                style: GoogleFonts.muli(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.5
                                )
                            )
                          ]
                        ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [

                            // criar o espaço para o código de verificação
                          ],
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
