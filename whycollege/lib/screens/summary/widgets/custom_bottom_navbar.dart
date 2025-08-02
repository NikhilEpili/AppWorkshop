import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xFF1F2937),
      buttonBackgroundColor: const Color(0xFFF59E0B),
      height: 65,
      animationDuration: const Duration(milliseconds: 300),
      index: currentIndex,
      onTap: onTap,
      items: const [
        Icon(Icons.home_outlined, size: 24, color: Colors.white),
        Icon(Icons.dashboard_outlined, size: 24, color: Colors.white),
        Icon(Icons.schedule_outlined, size: 24, color: Colors.white),
      ],
    );
  }
}