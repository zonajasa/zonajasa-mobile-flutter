import 'package:flutter/material.dart';

class Step3Screen extends StatelessWidget {
  const Step3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 100),
        Center(
          child: Text(
            "Step 3 (sementara kosong 😄)",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
