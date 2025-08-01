import 'package:flutter/material.dart';
import 'screens/attendance/view/attendance_page.dart';
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
      home: const AttendancePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}