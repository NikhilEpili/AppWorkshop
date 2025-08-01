class Subject {
  final String id;
  final String name;
  int attendedLectures;
  int totalLectures;

  Subject({
    required this.id,
    required this.name,
    required this.attendedLectures,
    required this.totalLectures,
  });

  // Calculate attendance percentage
  double get attendancePercentage {
    if (totalLectures == 0) return 0.0;
    return (attendedLectures / totalLectures) * 100;
  }

  // Check if attendance meets minimum threshold
  bool meetsThreshold(double threshold) {
    return attendancePercentage >= threshold;
  }

  // Create a copy with updated values
  Subject copyWith({
    String? id,
    String? name,
    int? attendedLectures,
    int? totalLectures,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      attendedLectures: attendedLectures ?? this.attendedLectures,
      totalLectures: totalLectures ?? this.totalLectures,
    );
  }

  // Convert to Map for future database integration
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'attendedLectures': attendedLectures,
      'totalLectures': totalLectures,
    };
  }

  // Create Subject from Map for future database integration
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      attendedLectures: map['attendedLectures'] ?? 0,
      totalLectures: map['totalLectures'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, attended: $attendedLectures, total: $totalLectures)';
  }
}