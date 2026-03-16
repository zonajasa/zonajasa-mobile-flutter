import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/pages/HomePage.dart';
import 'package:jasa_app/pages/profileUI.dart';

class Navigationpage extends StatefulWidget {
  const Navigationpage({super.key});

  @override
  State<Navigationpage> createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Container(),
    Container(),
    Profileui(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
