import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffe5e7eb), width: 1)),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Zones'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xff3b82f6),
        unselectedItemColor: const Color(0xff6b7280),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
      ),
    );
  }
}
