// lib/modules/timetable/widgets/day_edit_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DayEditDialog extends StatefulWidget {
  final String day;
  final List<String> currentSubjects;
  final List<String> availableSubjects;
  final Function(List<String>) onSave;

  const DayEditDialog({
    super.key,
    required this.day,
    required this.currentSubjects,
    required this.availableSubjects,
    required this.onSave,
  });

  @override
  State<DayEditDialog> createState() => _DayEditDialogState();
}

class _DayEditDialogState extends State<DayEditDialog> {
  late TextEditingController _lectureCountController;
  late List<String> _subjects;
  int _numberOfLectures = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _subjects = List<String>.from(widget.currentSubjects);
    _numberOfLectures = _subjects.length;
    _lectureCountController = TextEditingController(
      text: _subjects.isNotEmpty ? _subjects.length.toString() : '',
    );
  }

  @override
  void dispose() {
    _lectureCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1F2937),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_calendar,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit ${widget.day}',
                        style: const TextStyle(
                          color: Color(0xFFF9FAFB),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Configure your class schedule',
                        style: TextStyle(
                          color: const Color(0xFFF9FAFB).withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFF9FAFB),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Number of Lectures Input
            Text(
              'Number of Lectures',
              style: const TextStyle(
                color: Color(0xFFF9FAFB),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lectureCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: InputDecoration(
                hintText: 'Enter number of lectures (0-10)',
                hintStyle: TextStyle(
                  color: const Color(0xFFF9FAFB).withOpacity(0.5),
                ),
                filled: true,
                fillColor: const Color(0xFF111827),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF374151).withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF374151).withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFF59E0B),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFFF9FAFB),
                fontSize: 16,
              ),
              onChanged: (value) {
                final count = int.tryParse(value) ?? 0;
                if (count >= 0 && count <= 10) {
                  setState(() {
                    _numberOfLectures = count;
                    _updateSubjectsList();
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            // Subject Assignments
            if (_numberOfLectures > 0) ...[
              Text(
                'Subject Assignments',
                style: const TextStyle(
                  color: Color(0xFFF9FAFB),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _numberOfLectures,
                  itemBuilder: (context, index) => _buildSubjectDropdown(index),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: const Color(0xFF374151).withOpacity(0.5),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFFF9FAFB),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectDropdown(int index) {
    final availableOptions = [
      '',
      ...widget.availableSubjects
    ]; // Add empty option

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Lecture number indicator
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF93C5FD).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF93C5FD).withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Color(0xFF93C5FD),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Subject dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: index < _subjects.length && _subjects[index].isNotEmpty
                  ? _subjects[index]
                  : null,
              decoration: InputDecoration(
                hintText: 'Select Subject ${index + 1}',
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
                  if (index < _subjects.length) {
                    _subjects[index] = value ?? '';
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateSubjectsList() {
    if (_numberOfLectures > _subjects.length) {
      // Add empty subjects
      while (_subjects.length < _numberOfLectures) {
        _subjects.add('');
      }
    } else if (_numberOfLectures < _subjects.length) {
      // Remove excess subjects
      _subjects = _subjects.sublist(0, _numberOfLectures);
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Clean up subjects list (remove empty entries at the end)
      final cleanedSubjects = List<String>.from(_subjects);
      while (cleanedSubjects.isNotEmpty && cleanedSubjects.last.isEmpty) {
        cleanedSubjects.removeLast();
      }

      await widget.onSave(cleanedSubjects);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving changes: ${e.toString()}'),
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
