import 'package:flutter/material.dart';

class Profileui extends StatelessWidget {
  const Profileui({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // FOTO PROFILE
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/orang.png"),
            ),

            const SizedBox(height: 15),

            // NAMA
            const Text(
              "XioFik Hasan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            // LOKASI
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  "Sterling, Brooklyn",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // RATING DAN JOB
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  children: [
                    Icon(Icons.star, color: Colors.orange),
                    SizedBox(height: 5),
                    Text("4.5"),
                    Text("AVG rating"),
                  ],
                ),

                Column(
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.orange),
                    SizedBox(height: 5),
                    Text("Top 15%"),
                    Text("Current rank"),
                  ],
                ),

                Column(
                  children: [
                    Icon(Icons.work, color: Colors.green),
                    SizedBox(height: 5),
                    Text("20"),
                    Text("Total job"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // MENU PROFILE
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Profile Setting"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text("Location"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text("Manage Withdrawals"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
