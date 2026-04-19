import 'package:flutter/material.dart';
import 'package:jasa_app/ForgotAuth/resetCard.dart';

class ResetpasswordPage extends StatefulWidget {
  final String kodeUser;
  const ResetpasswordPage({super.key, required this.kodeUser});

  @override
  State<ResetpasswordPage> createState() => _ResetpasswordPageState();
}

class _ResetpasswordPageState extends State<ResetpasswordPage> {
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
                  Resetcard(kodeUser: widget.kodeUser),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
