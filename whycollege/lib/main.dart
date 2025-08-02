import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:whycollege/screens/timetable/view/timetable_page.dart';
import 'package:whycollege/screens/timetable/controller/timetable_controller.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimetableController()),
      ],
      child: MaterialApp(
        title: 'AppSprint',
        theme: ThemeData(
          primaryColor: const Color(0xFF111827),
          scaffoldBackgroundColor: const Color(0xFF111827),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111827),
            foregroundColor: Color(0xFFF9FAFB),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFFF9FAFB),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1F2937),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const MainNavigationPage(),
        debugShowCheckedModeBanner: false,
      ),
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
    const TimetablePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF1F2937),
        buttonBackgroundColor: const Color(0xFFF59E0B),
        height: 70,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, size: 26, color: Colors.white),
          Icon(Icons.dashboard_outlined, size: 26, color: Colors.white),
          Icon(Icons.schedule_outlined, size: 26, color: Colors.white),
        ],
      ),
    );
  }
}
