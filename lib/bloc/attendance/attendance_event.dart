part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  factory AttendanceEvent.emptyEvent()=> AttendanceEmptyEvent();
  factory AttendanceEvent.present(
          bool isPresent, String subjectId, String studentUid) =>
      IncrementPresent(subjectId: subjectId, studentUid: studentUid);
  factory AttendanceEvent.absent(String studentUid, String subjectId) =>
      IncrementAbsent(subjectId: subjectId, studentUid: studentUid);
  @override
  List<Object> get props => [];
}

class AttendanceEmptyEvent extends AttendanceEvent{}

class IncrementPresent extends AttendanceEvent{
  final String studentUid;
  final String subjectId;

  IncrementPresent({required this.subjectId, required this.studentUid});

  @override
  List<String> get props => [subjectId, studentUid];
}

class IncrementAbsent extends AttendanceEvent {
  final String studentUid;
  final String subjectId;

  IncrementAbsent({required this.subjectId, required this.studentUid});

  @override
  List<String> get props => [subjectId, studentUid];
}
