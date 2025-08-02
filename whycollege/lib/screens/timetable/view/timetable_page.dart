// lib/modules/timetable/view/timetable_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/timetable_controller.dart';
import '../widgets/day_edit_dialog.dart';
import '../widgets/todays_schedule_card.dart';
import '../widgets/weekly_timetable_section.dart';
import 'create_timetable_screen.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimetableController>(context, listen: false).loadTimetable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        title: const Text(
          'AppSprint',
          style: TextStyle(
            color: Color(0xFFF9FAFB),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateTimetableScreen(),
              ),
            ),
            icon: const Icon(
              Icons.edit,
              color: Color(0xFFF9FAFB),
            ),
          ),
        ],
      ),
      body: Consumer<TimetableController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF59E0B),
              ),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[400],
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.error!,
                    style: const TextStyle(
                      color: Color(0xFFF9FAFB),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.clearError();
                      controller.loadTimetable();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFF59E0B),
            backgroundColor: const Color(0xFF1F2937),
            onRefresh: () async {
              await controller.loadTimetable();
              await controller.loadSubjects();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Schedule Card
                  TodaysScheduleCard(
                    currentDay: controller.getCurrentDay(),
                    todaysSubjects: controller.getTodaysSubjects(),
                    onMarkAttendance: () =>
                        _markAttendance(context, controller),
                  ),

                  const SizedBox(height: 24),

                  // Weekly Timetable Section
                  const Text(
                    'Weekly Timetable',
                    style: TextStyle(
                      color: Color(0xFFF9FAFB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  WeeklyTimetableSection(
                    timetable: controller.timetable,
                    subjects: controller.subjects,
                    onDayEdit: (day) =>
                        _showDayEditDialog(context, day, controller),
                    onSubjectChange: (day, index, subject) =>
                        _updateSubjectInDay(controller, day, index, subject),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _markAttendance(
      BuildContext context, TimetableController controller) async {
    try {
      await controller.markTodaysAttendance();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance marked successfully!'),
            backgroundColor: Color(0xFFF59E0B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showDayEditDialog(
      BuildContext context, String day, TimetableController controller) {
    showDialog(
      context: context,
      builder: (context) => DayEditDialog(
        day: day,
        currentSubjects: controller.getTimetableForDay(day).subjects,
        availableSubjects: controller.subjects.map((s) => s.name).toList(),
        onSave: (subjects) => controller.updateTimetableDay(day, subjects),
      ),
    );
  }

  void _updateSubjectInDay(
      TimetableController controller, String day, int index, String? subject) {
    final currentTimetable = controller.getTimetableForDay(day);
    final updatedSubjects = List<String>.from(currentTimetable.subjects);

    // Ensure the list is long enough
    while (updatedSubjects.length <= index) {
      updatedSubjects.add('');
    }

    updatedSubjects[index] = subject ?? '';
    controller.updateTimetableDay(day, updatedSubjects);
  }
}
