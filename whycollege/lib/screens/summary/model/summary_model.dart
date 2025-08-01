class Attendance {
  final int attendedLectures;
  final int totalLectures;

  Attendance({required this.attendedLectures, required this.totalLectures});

  double get percentage =>
      totalLectures == 0 ? 0 : (attendedLectures / totalLectures) * 100;

  String get status {
    if (percentage >= 75) {
      return "Good Attendance";
    } else if (percentage >= 50) {
      return "Moderate Attendance";
    } else {
      return "Poor Attendance";
    }
  }

  String get statusIcon {
    if (percentage >= 75) {
      return "✅";
    } else if (percentage >= 50) {
      return "⚠️";
    } else {
      return "❌";
    }
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendedLectures: json['attended_lectures'] ?? 0,
      totalLectures: json['total_lectures'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attended_lectures': attendedLectures,
      'total_lectures': totalLectures,
    };
  }
}