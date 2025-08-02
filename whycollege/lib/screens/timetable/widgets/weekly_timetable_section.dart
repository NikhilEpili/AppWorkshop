// lib/modules/timetable/widgets/weekly_timetable_section.dart

import 'package:flutter/material.dart';
import '../model/timetable_model.dart';

class WeeklyTimetableSection extends StatelessWidget {
  final List<TimetableDay> timetable;
  final List<Subject> subjects;
  final Function(String) onDayEdit;
  final Function(String, int, String?) onSubjectChange;

  const WeeklyTimetableSection({
    super.key,
    required this.timetable,
    required this.subjects,
    required this.onDayEdit,
    required this.onSubjectChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: timetable.map((dayTimetable) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF374151).withOpacity(0.5),
              ),
            ),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              backgroundColor: const Color(0xFF1F2937),
              collapsedBackgroundColor: const Color(0xFF1F2937),
              iconColor: const Color(0xFFF59E0B),
              collapsedIconColor: const Color(0xFFF9FAFB).withOpacity(0.7),
              title: Row(
                children: [
                  // Day indicator
                  _getDayIcon(dayTimetable.day),
                  const SizedBox(width: 12),

                  // Day name and subject count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayTimetable.day,
                          style: const TextStyle(
                            color: Color(0xFFF9FAFB),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getSubjectCountText(dayTimetable.subjects),
                          style: TextStyle(
                            color: const Color(0xFFF9FAFB).withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  IconButton(
                    onPressed: () => onDayEdit(dayTimetable.day),
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                    ),
                    color: const Color(0xFF93C5FD),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              children: [
                if (dayTimetable.subjects.isEmpty)
                  _buildEmptyState()
                else
                  _buildSubjectsList(dayTimetable),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _getDayIcon(String day) {
    IconData icon;
    Color color;

    switch (day.toLowerCase()) {
      case 'monday':
        icon = Icons.work_outline;
        color = const Color(0xFF93C5FD);
        break;
      case 'tuesday':
        icon = Icons.school_outlined;
        color = const Color(0xFFF59E0B);
        break;
      case 'wednesday':
        icon = Icons.book_outlined;
        color = const Color(0xFF34D399);
        break;
      case 'thursday':
        icon = Icons.assignment_outlined;
        color = const Color(0xFFE879F9);
        break;
      case 'friday':
        icon = Icons.weekend_outlined;
        color = const Color(0xFFFBBF24);
        break;
      case 'saturday':
        icon = Icons.sports_basketball_outlined;
        color = const Color(0xFF60A5FA);
        break;
      case 'sunday':
        icon = Icons.home_outlined;
        color = const Color(0xFFF87171);
        break;
      default:
        icon = Icons.calendar_today_outlined;
        color = const Color(0xFFF9FAFB);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  String _getSubjectCountText(List<String> subjects) {
    final activeSubjects = subjects.where((s) => s.isNotEmpty).length;
    if (activeSubjects == 0) {
      return 'No classes scheduled';
    } else if (activeSubjects == 1) {
      return '1 class scheduled';
    } else {
      return '$activeSubjects classes scheduled';
    }
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: const Color(0xFFF9FAFB).withOpacity(0.3),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No classes scheduled',
            style: TextStyle(
              color: const Color(0xFFF9FAFB).withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap the edit icon to add subjects',
            style: TextStyle(
              color: const Color(0xFFF9FAFB).withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(TimetableDay dayTimetable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ...List.generate(
          dayTimetable.subjects.length,
          (index) => _buildSubjectDropdown(
              dayTimetable.day, index, dayTimetable.subjects[index]),
        ),
      ],
    );
  }

  Widget _buildSubjectDropdown(String day, int index, String currentSubject) {
    final subjectNames = subjects.map((s) => s.name).toList();
    subjectNames.insert(0, ''); // Add empty option

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Lecture number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFF59E0B).withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Subject dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: currentSubject.isEmpty ? null : currentSubject,
              decoration: InputDecoration(
                hintText: 'Select Subject',
                hintStyle: TextStyle(
                  color: const Color(0xFFF9FAFB).withOpacity(0.5),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFF111827),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF374151).withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF374151).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFF59E0B),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              dropdownColor: const Color(0xFF1F2937),
              style: const TextStyle(
                color: Color(0xFFF9FAFB),
                fontSize: 14,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFF9FAFB),
              ),
              items: subjectNames.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject.isEmpty ? null : subject,
                  child: Text(
                    subject.isEmpty ? 'No Subject' : subject,
                    style: TextStyle(
                      color: subject.isEmpty
                          ? const Color(0xFFF9FAFB).withOpacity(0.5)
                          : const Color(0xFFF9FAFB),
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) => onSubjectChange(day, index, value),
            ),
          ),
        ],
      ),
    );
  }
}
