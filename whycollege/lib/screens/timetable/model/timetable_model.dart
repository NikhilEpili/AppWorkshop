// lib/modules/timetable/model/timetable_day.dart

class TimetableDay {
  final String day;
  final List<String> subjects;
  final String? id; // For Supabase integration

  TimetableDay({
    required this.day,
    required this.subjects,
    this.id,
  });

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'subjects': subjects,
    };
  }

  // Create from JSON (from Supabase)
  factory TimetableDay.fromJson(Map<String, dynamic> json) {
    return TimetableDay(
      id: json['id']?.toString(),
      day: json['day'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
    );
  }

  // Create a copy with updated values
  TimetableDay copyWith({
    String? day,
    List<String>? subjects,
    String? id,
  }) {
    return TimetableDay(
      day: day ?? this.day,
      subjects: subjects ?? this.subjects,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'TimetableDay(day: $day, subjects: $subjects, id: $id)';
  }
}

// Subject model (shared with Home module)
class Subject {
  final String? id;
  final String name;
  final int attended;
  final int total;
  final String color;

  Subject({
    this.id,
    required this.name,
    required this.attended,
    required this.total,
    required this.color,
  });

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'attended': attended,
      'total': total,
      'color': color,
    };
  }

  // Create from JSON (from Supabase)
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      attended: json['attended'] ?? 0,
      total: json['total'] ?? 0,
      color: json['color'] ?? '#F59E0B',
    );
  }

  // Create a copy with updated values
  Subject copyWith({
    String? id,
    String? name,
    int? attended,
    int? total,
    String? color,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      attended: attended ?? this.attended,
      total: total ?? this.total,
      color: color ?? this.color,
    );
  }

  double get attendancePercentage {
    if (total == 0) return 0.0;
    return (attended / total) * 100;
  }

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, attended: $attended, total: $total)';
  }
}
