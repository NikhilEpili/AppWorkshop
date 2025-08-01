import 'package:flutter/material.dart';
import '../model/subject_model.dart';
import '../../../sample_data.dart';

class AttendanceController extends ChangeNotifier {
  List<Subject> _subjects = [];
  double _minimumThreshold = 75.0;

  // Getters
  List<Subject> get subjects => _subjects;
  double get minimumThreshold => _minimumThreshold;

  // Constructor - Initialize with sample data
  AttendanceController() {
    _loadSubjects();
  }

  // Load subjects from sample data (later replace with Supabase)
  void _loadSubjects() {
    _subjects = SampleData.getSubjects();
    notifyListeners();
  }

  // Update minimum attendance threshold
  void updateThreshold(double newThreshold) {
    _minimumThreshold = newThreshold;
    notifyListeners();
  }

  // Add a new subject
  void addSubject(String name, int attendedLectures, int totalLectures) {
    final newSubject = Subject(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      attendedLectures: attendedLectures,
      totalLectures: totalLectures,
    );
    
    _subjects.add(newSubject);
    notifyListeners();
    
    // TODO: Later implement Supabase insertion
    // await _supabaseService.insertSubject(newSubject);
  }

  // Mark attendance as present (increment both attended and total)
  void markPresent(String subjectId) {
    final index = _subjects.indexWhere((subject) => subject.id == subjectId);
    if (index != -1) {
      _subjects[index] = _subjects[index].copyWith(
        attendedLectures: _subjects[index].attendedLectures + 1,
        totalLectures: _subjects[index].totalLectures + 1,
      );
      notifyListeners();
      
      // TODO: Later implement Supabase update
      // await _supabaseService.updateSubject(_subjects[index]);
    }
  }

  // Mark attendance as absent (increment only total)
  void markAbsent(String subjectId) {
    final index = _subjects.indexWhere((subject) => subject.id == subjectId);
    if (index != -1) {
      _subjects[index] = _subjects[index].copyWith(
        totalLectures: _subjects[index].totalLectures + 1,
      );
      notifyListeners();
      
      // TODO: Later implement Supabase update
      // await _supabaseService.updateSubject(_subjects[index]);
    }
  }

  // Delete a subject
  void deleteSubject(String subjectId) {
    _subjects.removeWhere((subject) => subject.id == subjectId);
    notifyListeners();
    
    // TODO: Later implement Supabase deletion
    // await _supabaseService.deleteSubject(subjectId);
  }

  // Get subject by ID
  Subject? getSubjectById(String id) {
    try {
      return _subjects.firstWhere((subject) => subject.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get subjects with low attendance
  List<Subject> getSubjectsWithLowAttendance() {
    return _subjects.where((subject) => 
      !subject.meetsThreshold(_minimumThreshold)
    ).toList();
  }

  // Get overall attendance statistics
  Map<String, dynamic> getOverallStats() {
    if (_subjects.isEmpty) {
      return {
        'totalSubjects': 0,
        'averageAttendance': 0.0,
        'subjectsAtRisk': 0,
      };
    }

    final totalAttended = _subjects.fold<int>(
      0, (sum, subject) => sum + subject.attendedLectures
    );
    final totalLectures = _subjects.fold<int>(
      0, (sum, subject) => sum + subject.totalLectures
    );
    
    final averageAttendance = totalLectures > 0 
      ? (totalAttended / totalLectures) * 100 
      : 0.0;
    
    final subjectsAtRisk = getSubjectsWithLowAttendance().length;

    return {
      'totalSubjects': _subjects.length,
      'averageAttendance': averageAttendance,
      'subjectsAtRisk': subjectsAtRisk,
      'totalAttended': totalAttended,
      'totalLectures': totalLectures,
    };
  }

  // Refresh data (for future Supabase integration)
  Future<void> refreshData() async {
    // TODO: Implement Supabase data refresh
    // _subjects = await _supabaseService.getSubjects();
    // notifyListeners();
    
    // For now, just reload sample data
    _loadSubjects();
  }
}