import 'package:flutter/material.dart';
import 'package:jasa_app/ForgotAuth/forgotCard.dart';

class Forgotpasswordpage extends StatelessWidget {
  const Forgotpasswordpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xffeeeefa),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff0247ae), Color(0xff0e86e4)],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 260,
                      width: 260,
                      margin: EdgeInsets.only(left: 1, top: 35),
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  Forgotcard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
