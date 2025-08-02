// lib/modules/timetable/controller/timetable_controller.dart

import 'package:flutter/material.dart';
import '../model/timetable_model.dart';

class TimetableController extends ChangeNotifier {
  // Hardcoded data for now
  List<TimetableDay> _timetable = [
    TimetableDay(day: 'Monday', subjects: ['Math', 'Physics']),
    TimetableDay(day: 'Tuesday', subjects: ['Chemistry', 'Biology']),
    TimetableDay(day: 'Wednesday', subjects: ['English', 'History']),
    TimetableDay(day: 'Thursday', subjects: ['Geography', 'PE']),
    TimetableDay(day: 'Friday', subjects: ['Computer Science', 'Art']),
    TimetableDay(day: 'Saturday', subjects: []),
    TimetableDay(day: 'Sunday', subjects: []),
  ];

  final List<Subject> _subjects = [
    Subject(id: '1', name: 'Math', attended: 5, total: 6, color: '#F59E0B'),
    Subject(id: '2', name: 'Physics', attended: 4, total: 6, color: '#3B82F6'),
    Subject(id: '3', name: 'Chemistry', attended: 6, total: 6, color: '#10B981'),
    Subject(id: '4', name: 'Biology', attended: 3, total: 6, color: '#EF4444'),
    Subject(id: '5', name: 'English', attended: 6, total: 6, color: '#8B5CF6'),
    Subject(id: '6', name: 'History', attended: 2, total: 6, color: '#F97316'),
    Subject(id: '7', name: 'Geography', attended: 4, total: 6, color: '#06B6D4'),
    Subject(id: '8', name: 'PE', attended: 5, total: 6, color: '#84CC16'),
    Subject(id: '9', name: 'Computer Science', attended: 6, total: 6, color: '#EC4899'),
    Subject(id: '10', name: 'Art', attended: 3, total: 6, color: '#F59E0B'),
  ];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<TimetableDay> get timetable => _timetable;
  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Days of the week
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  TimetableController() {
    // No need to load from Supabase, just use hardcoded data
  }

  // Get current day name
  String getCurrentDay() {
    final now = DateTime.now();
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return dayNames[now.weekday - 1];
  }

  // Get today's subjects
  List<String> getTodaysSubjects() {
    final today = getCurrentDay();
    final todayTimetable = _timetable.firstWhere(
      (day) => day.day == today,
      orElse: () => TimetableDay(day: today, subjects: []),
    );
    return todayTimetable.subjects.where((subject) => subject.isNotEmpty).toList();
  }

  // Dummy load methods (do nothing)
  Future<void> loadTimetable() async {
    // No-op for hardcoded data
    notifyListeners();
  }

  Future<void> loadSubjects() async {
    // No-op for hardcoded data
    notifyListeners();
  }

  // Update timetable day (local only)
  Future<void> updateTimetableDay(String day, List<String> subjects) async {
    final index = _timetable.indexWhere((t) => t.day == day);
    if (index != -1) {
      _timetable[index] = _timetable[index].copyWith(subjects: subjects);
      notifyListeners();
    }
  }

  // Mark attendance for today's subjects (local only)
  Future<void> markTodaysAttendance() async {
    final todaysSubjects = getTodaysSubjects();
    if (todaysSubjects.isEmpty) {
      _setError('No subjects scheduled for today');
      return;
    }
    for (String subjectName in todaysSubjects) {
      final subjectIndex = _subjects.indexWhere((s) => s.name == subjectName);
      if (subjectIndex != -1) {
        final subject = _subjects[subjectIndex];
        _subjects[subjectIndex] = subject.copyWith(
          attended: subject.attended + 1,
          total: subject.total + 1,
        );
      }
    }
    notifyListeners();
    _setError(null);
  }

  // Get timetable for specific day
  TimetableDay getTimetableForDay(String day) {
    return _timetable.firstWhere(
      (t) => t.day == day,
      orElse: () => TimetableDay(day: day, subjects: []),
    );
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
