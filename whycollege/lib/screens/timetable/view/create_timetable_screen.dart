// lib/modules/timetable/view/create_timetable_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/timetable_controller.dart';
import '../widgets/day_schedule_editor.dart';

class CreateTimetableScreen extends StatefulWidget {
  const CreateTimetableScreen({super.key});

  @override
  State<CreateTimetableScreen> createState() => _CreateTimetableScreenState();
}

class _CreateTimetableScreenState extends State<CreateTimetableScreen> {
  late Map<String, List<String>> _weeklySchedule;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSchedule();
  }

  void _initializeSchedule() {
    final controller = Provider.of<TimetableController>(context, listen: false);
    _weeklySchedule = {};

    for (String day in controller.daysOfWeek) {
      final dayTimetable = controller.getTimetableForDay(day);
      _weeklySchedule[day] = List<String>.from(dayTimetable.subjects);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFF9FAFB),
          ),
        ),
        title: const Text(
          'Create Timetable',
          style: TextStyle(
            color: Color(0xFFF9FAFB),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Color(0xFFF59E0B),
                  strokeWidth: 2,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveTimetable,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Consumer<TimetableController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF93C5FD).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF93C5FD),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Instructions',
                            style: TextStyle(
                              color: Color(0xFF93C5FD),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Set up your weekly class schedule by selecting subjects for each day. You can add multiple lectures per day and choose from your subjects list.',
                        style: TextStyle(
                          color: Color(0xFFF9FAFB),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Weekly Schedule Editors
                ...controller.daysOfWeek.map((day) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DayScheduleEditor(
                      day: day,
                      subjects: _weeklySchedule[day] ?? [],
                      availableSubjects:
                          controller.subjects.map((s) => s.name).toList(),
                      onSubjectsChanged: (updatedSubjects) {
                        setState(() {
                          _weeklySchedule[day] = updatedSubjects;
                        });
                      },
                    ),
                  );
                }).toList(),

                const SizedBox(height: 32),

                // Save Button (Alternative)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveTimetable,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Timetable',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveTimetable() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final controller =
          Provider.of<TimetableController>(context, listen: false);

      // Save each day's schedule
      for (String day in controller.daysOfWeek) {
        final subjects = _weeklySchedule[day] ?? [];
        await controller.updateTimetableDay(day, subjects);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timetable saved successfully!'),
            backgroundColor: Color(0xFFF59E0B),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving timetable: ${e.toString()}'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
