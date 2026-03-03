import 'package:flutter/material.dart';

class SplashS extends StatelessWidget {
  const SplashS({super.key});

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
                  Container(
                    height: 300,
                    width: 300,
                    margin: EdgeInsets.only(left: 45, top: 45),
                    child: Image.asset('images/logo.png'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
