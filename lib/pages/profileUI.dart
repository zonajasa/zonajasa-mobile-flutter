import 'package:flutter/material.dart';

class Profileui extends StatelessWidget {
  const Profileui({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeeeefa),
      appBar: AppBar(
        title: const Text("Akun Saya"),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Text("Profile Page", style: TextStyle(fontSize: 18)),
      ),
    );

  }
}
