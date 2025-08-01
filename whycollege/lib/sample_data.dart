import 'screens/attendance/model/subject_model.dart';

class SampleData {
  static List<Subject> getSubjects() {
    return [
      Subject(
        id: '1',
        name: 'Mathematics',
        attendedLectures: 18,
        totalLectures: 20,
      ),
      Subject(
        id: '2',
        name: 'Physics',
        attendedLectures: 15,
        totalLectures: 20,
      ),
      Subject(
        id: '3',
        name: 'Chemistry',
        attendedLectures: 12,
        totalLectures: 18,
      ),
      Subject(
        id: '4',
        name: 'Computer Science',
        attendedLectures: 22,
        totalLectures: 25,
      ),
      Subject(
        id: '5',
        name: 'English Literature',
        attendedLectures: 14,
        totalLectures: 16,
      ),
      Subject(
        id: '6',
        name: 'History',
        attendedLectures: 10,
        totalLectures: 15,
      ),
    ];
  }
}