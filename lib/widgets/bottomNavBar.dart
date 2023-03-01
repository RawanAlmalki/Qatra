import 'package:flutter/material.dart';

class bottomNavBar extends StatelessWidget {
  bottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 85, 140, 143),
      iconSize: 25,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: const Color.fromARGB(255, 176, 228, 231),
      onTap: onTap,
    );
  }
}
