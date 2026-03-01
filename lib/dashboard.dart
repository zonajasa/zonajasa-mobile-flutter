import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  BottomNavigationBarType _bottomNavType = BottomNavigationBarType.fixed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xffeeeefa),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff0e86e4),
        unselectedItemColor: const Color(0xff757575),
        type: _bottomNavType,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            icon: FaIcon(FontAwesomeIcons.house),
            activeIcon: FaIcon(FontAwesomeIcons.solidHouse),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            icon: FaIcon(FontAwesomeIcons.circleUp),
            // ignore: deprecated_member_use
            activeIcon: FaIcon(FontAwesomeIcons.solidCircleUp),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.commentDots),
            activeIcon: FaIcon(FontAwesomeIcons.solidCommentDots),
            label: 'Chat',
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
