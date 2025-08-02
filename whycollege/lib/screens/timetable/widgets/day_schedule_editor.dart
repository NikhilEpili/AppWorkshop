// lib/modules/timetable/widgets/day_schedule_editor.dart

import 'package:flutter/material.dart';

class DayScheduleEditor extends StatefulWidget {
  final String day;
  final List<String> subjects;
  final List<String> availableSubjects;
  final Function(List<String>) onSubjectsChanged;

  const DayScheduleEditor({
    super.key,
    required this.day,
    required this.subjects,
    required this.availableSubjects,
    required this.onSubjectsChanged,
  });

  @override
  State<DayScheduleEditor> createState() => _DayScheduleEditorState();
}

class _DayScheduleEditorState extends State<DayScheduleEditor> {
  late List<String> _currentSubjects;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentSubjects = List<String>.from(widget.subjects);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF374151).withOpacity(0.5),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: const Color(0xFF1F2937),
        collapsedBackgroundColor: const Color(0xFF1F2937),
        iconColor: const Color(0xFFF59E0B),
        collapsedIconColor: const Color(0xFFF9FAFB).withOpacity(0.7),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Row(
          children: [
            // Day icon
            _getDayIcon(widget.day),
            const SizedBox(width: 12),

            // Day info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.day,
                    style: const TextStyle(
                      color: Color(0xFFF9FAFB),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getSubjectCountText(),
                    style: TextStyle(
                      color: const Color(0xFFF9FAFB).withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Quick action buttons
            if (!_isExpanded) ...[
              _buildQuickActionButton(
                icon: Icons.add,
                color: const Color(0xFF34D399),
                onPressed: _addLecture,
              ),
              const SizedBox(width: 4),
              if (_currentSubjects.isNotEmpty)
                _buildQuickActionButton(
                  icon: Icons.remove,
                  color: const Color(0xFFF87171),
                  onPressed: _removeLecture,
                ),
            ],
          ],
        ),
        children: [
          _buildExpandedContent(),
        ],
      ),
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

  Widget _buildQuickActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 14, color: color),
        color: color,
        padding: EdgeInsets.zero,
      ),
    );
  }

  String _getSubjectCountText() {
    final activeSubjects = _currentSubjects.where((s) => s.isNotEmpty).length;
    if (activeSubjects == 0) {
      return 'No classes scheduled';
    } else if (activeSubjects == 1) {
      return '1 class scheduled';
    } else {
      return '$activeSubjects classes scheduled';
    }
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with controls
        Row(
          children: [
            const Text(
              'Lectures',
              style: TextStyle(
                color: Color(0xFFF9FAFB),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _buildQuickActionButton(
              icon: Icons.add,
              color: const Color(0xFF34D399),
              onPressed: _addLecture,
            ),
            const SizedBox(width: 8),
            if (_currentSubjects.isNotEmpty)
              _buildQuickActionButton(
                icon: Icons.remove,
                color: const Color(0xFFF87171),
                onPressed: _removeLecture,
              ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              icon: Icons.clear_all,
              color: const Color(0xFF6B7280),
              onPressed: _clearAll,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Subject dropdowns
        if (_currentSubjects.isEmpty)
          _buildEmptyState()
        else
          ..._currentSubjects.asMap().entries.map((entry) {
            final index = entry.key;
            final subject = entry.value;
            return _buildSubjectDropdown(index, subject);
          }).toList(),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF374151).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: const Color(0xFFF9FAFB).withOpacity(0.3),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No lectures scheduled',
            style: TextStyle(
              color: const Color(0xFFF9FAFB).withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add a lecture',
            style: TextStyle(
              color: const Color(0xFFF9FAFB).withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectDropdown(int index, String currentSubject) {
    final availableOptions = ['', ...widget.availableSubjects];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
                  vertical: 10,
                ),
                isDense: true,
              ),
              dropdownColor: const Color(0xFF1F2937),
              style: const TextStyle(
                color: Color(0xFFF9FAFB),
                fontSize: 14,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFF9FAFB),
                size: 20,
              ),
              items: availableOptions.map((subject) {
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
              onChanged: (value) {
                setState(() {
                  _currentSubjects[index] = value ?? '';
                });
                widget.onSubjectsChanged(_currentSubjects);
              },
            ),
          ),

          const SizedBox(width: 8),

          // Remove button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFF87171).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFF87171).withOpacity(0.3),
              ),
            ),
            child: IconButton(
              onPressed: () => _removeSpecificLecture(index),
                             icon: const Icon(Icons.close, size: 14, color: Color(0xFFF87171)),
              color: const Color(0xFFF87171),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _addLecture() {
    setState(() {
      _currentSubjects.add('');
    });
    widget.onSubjectsChanged(_currentSubjects);
  }

  void _removeLecture() {
    if (_currentSubjects.isNotEmpty) {
      setState(() {
        _currentSubjects.removeLast();
      });
      widget.onSubjectsChanged(_currentSubjects);
    }
  }

  void _removeSpecificLecture(int index) {
    setState(() {
      _currentSubjects.removeAt(index);
    });
    widget.onSubjectsChanged(_currentSubjects);
  }

  void _clearAll() {
    setState(() {
      _currentSubjects.clear();
    });
    widget.onSubjectsChanged(_currentSubjects);
  }
}
