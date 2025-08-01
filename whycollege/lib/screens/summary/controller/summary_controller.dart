import 'package:flutter/material.dart';
import '../model/summary_model.dart';
import '../model/user_settings.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class SummaryController extends ChangeNotifier {
  Attendance? _attendance;
  UserSettings _userSettings = UserSettings();
  bool _isLoading = false;
  String? _error;

  // Getters
  Attendance? get attendance => _attendance;
  UserSettings get userSettings => _userSettings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Mock data for demonstration
  Future<void> fetchAttendanceData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data - replace with actual Supabase call
      _attendance = Attendance(
        attendedLectures: 20,
        totalLectures: 28,
      );

      /* Actual Supabase implementation would look like:
      final response = await Supabase.instance.client
          .from('attendance')
          .select('*')
          .eq('user_id', userId)
          .single();
      
      _attendance = Attendance.fromJson(response);
      */

    } catch (e) {
      _error = 'Failed to load attendance data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserSettings() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock data - replace with actual Supabase call
      _userSettings = UserSettings(attendanceThreshold: 75.0);

      /* Actual Supabase implementation:
      final response = await Supabase.instance.client
          .from('user_settings')
          .select('*')
          .eq('user_id', userId)
          .single();
      
      _userSettings = UserSettings.fromJson(response);
      */

      notifyListeners();
    } catch (e) {
      // Handle error silently for settings
      debugPrint('Error fetching user settings: $e');
    }
  }

  Future<void> updateAttendanceThreshold(double threshold) async {
    try {
      // Update local state immediately
      _userSettings = UserSettings(attendanceThreshold: threshold);
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      /* Actual Supabase implementation:
      await Supabase.instance.client
          .from('user_settings')
          .update({'attendance_threshold': threshold})
          .eq('user_id', userId);
      */

    } catch (e) {
      _error = 'Failed to update threshold: $e';
      notifyListeners();
    }
  }

  String getAttendanceStatus() {
    if (_attendance == null) return "No Data";
    
    if (_attendance!.percentage >= _userSettings.attendanceThreshold) {
      return "✅ Good Attendance";
    } else {
      return "⚠️ Moderate Attendance";
    }
  }

  Color getStatusColor() {
    if (_attendance == null) return Colors.grey;
    
    if (_attendance!.percentage >= _userSettings.attendanceThreshold) {
      return const Color(0xFF10B981); // Green
    } else {
      return const Color(0xFFF59E0B); // Orange
    }
  }
}