class UserSettings {
  final double attendanceThreshold;

  UserSettings({this.attendanceThreshold = 75.0});

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      attendanceThreshold: (json['attendance_threshold'] ?? 75.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_threshold': attendanceThreshold,
    };
  }
}