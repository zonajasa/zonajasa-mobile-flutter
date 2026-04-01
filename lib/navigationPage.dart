import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/pages/HomePage.dart';
import 'package:jasa_app/pages/notifikasiScreen.dart';
import 'package:jasa_app/pages/pesanan/ui_pemesanan.dart';
import 'package:jasa_app/pages/profileUI.dart';

class Navigationpage extends StatefulWidget {
  final int initialIndex;
  const Navigationpage({super.key, this.initialIndex = 0});

  @override
  State<Navigationpage> createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  late int _selectedIndex;
  DateTime? lastBackPressed;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomePage(),
    PemesananPage(),
    Notifikasiscreen(),
    Profileui(),
  ];
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return;
        }

        final now = DateTime.now();

        if (lastBackPressed == null ||
            now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
          lastBackPressed = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tekan sekali lagi untuk keluar'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          Navigator.of(context).pop(); // 🔥 exit app
        }
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff0e86e4),
          unselectedItemColor: const Color(0xff757575),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              activeIcon: FaIcon(FontAwesomeIcons.solidHouse),
              label: 'Beranda',
            ),

            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList),
              activeIcon: FaIcon(FontAwesomeIcons.clipboardList),
              label: 'Pemesanan',
            ),

            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell),
              activeIcon: FaIcon(FontAwesomeIcons.solidBell),
              label: 'Notifikasi',
            ),

            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              activeIcon: FaIcon(FontAwesomeIcons.solidUser),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}
