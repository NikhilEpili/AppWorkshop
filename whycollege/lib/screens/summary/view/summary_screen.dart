import 'package:flutter/material.dart';
import '../controller/summary_controller.dart';
import '../widgets/threshold_dialog.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/summary_card.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late SummaryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SummaryController();
    _controller.fetchAttendanceData();
    _controller.fetchUserSettings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showThresholdDialog() {
    showDialog(
      context: context,
      builder: (context) => ThresholdDialog(
        currentThreshold: _controller.userSettings.attendanceThreshold,
        onThresholdChanged: (threshold) {
          _controller.updateAttendanceThreshold(threshold);
        },
      ),
    );
  }

  void _onBottomNavTap(int index) {
    // Handle navigation to different screens
    switch (index) {
      case 0:
        // Navigate to Home
        // Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Already on Dashboard
        break;
      case 2:
        // Navigate to Timetable
        // Navigator.pushReplacementNamed(context, '/timetable');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF111827),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1F2937),
            elevation: 0,
            title: const Text(
              'AppSprint',
              style: TextStyle(
                color: Color(0xFFF9FAFB),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showThresholdDialog,
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFFF9FAFB),
                ),
              ),
            ],
          ),
          body: _buildBody(),
          bottomNavigationBar: CustomBottomNavbar(
            currentIndex: 1, // Dashboard is selected
            onTap: _onBottomNavTap,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
        ),
      );
    }

    if (_controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFF59E0B),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _controller.error!,
              style: const TextStyle(
                color: Color(0xFFF9FAFB),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _controller.fetchAttendanceData();
                _controller.fetchUserSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: const Color(0xFF111827),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_controller.attendance == null) {
      return const Center(
        child: Text(
          'No attendance data available',
          style: TextStyle(
            color: Color(0xFFF9FAFB),
            fontSize: 16,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SummaryCard(
        attendance: _controller.attendance!,
        status: _controller.getAttendanceStatus(),
        statusColor: _controller.getStatusColor(),
      ),
    );
  }
}
