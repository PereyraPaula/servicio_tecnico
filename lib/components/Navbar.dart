import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const Navbar({
    Key? key,
    required this.onTabSelected,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF2A3D53),
      selectedItemColor: const Color(0xFFC0CDEC),
      unselectedItemColor: Colors.white,
    );
  }
}
