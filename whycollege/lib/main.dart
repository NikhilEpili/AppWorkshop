import 'package:flutter/material.dart';
import 'screens/attendance/view/attendance_page.dart';
import 'screens/summary/view/summary_screen.dart';
import 'theme.dart';

void main() {
  runApp(const AppSprintApp());
}

class AppSprintApp extends StatelessWidget {
  const AppSprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppSprint',
      theme: AppTheme.lightTheme,
      home: const MainNavigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AttendancePage(),
    const SummaryScreen(),
    const PlaceholderPage(), // Placeholder for Timetable
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceColor,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: const Color(0xFF95A5A6),
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_outlined),
            activeIcon: Icon(Icons.schedule),
            label: 'Timetable',
          ),
        ],
      ),
    );
  }
}

// Placeholder page for Timetable (to be implemented later)
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppSprint'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: Color(0xFF95A5A6),
            ),
            SizedBox(height: 16),
            Text(
              'Timetable Coming Soon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF95A5A6),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This feature will be implemented soon',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF95A5A6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}