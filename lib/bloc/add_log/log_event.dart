part of 'log_bloc.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();
  factory LogEvent.empty() => LogEmptyEvent();
  factory LogEvent.increment(String subjectName, bool isPresent, int timestamp,
          String studentUid) =>
      LogIncrementEvent(
          studentUid: studentUid,
          isPresent: isPresent,
          subjectName: subjectName,
          timestamp: timestamp);
  factory LogEvent.getAll(String userId) => GetAllLogs(userId: userId);
  factory LogEvent.addSubject(String subjectName) =>
      LogSubjectAdd(subjectName: subjectName);

      factory LogEvent.deleteLogs(String userId) => DeleteLogs(userId: userId);

  @override
  List<Object> get props => [];
}

class LogEmptyEvent extends LogEvent {
  @override
  List<Object> get props => [];
}

class LogSubjectAdd extends LogEvent {
  final String subjectName;
  LogSubjectAdd({required this.subjectName});
  @override
  List<String> get props => [];
}

class LogIncrementEvent extends LogEvent {
  final String subjectName;
  final bool isPresent;
  final int timestamp;
  final String studentUid;

  LogIncrementEvent(
      {required this.isPresent,
      required this.studentUid,
      required this.subjectName,
      required this.timestamp});
  @override
  List<Object> get props => [subjectName, isPresent, timestamp];
}

class GetAllLogs extends LogEvent {
  final String userId;
  GetAllLogs({required this.userId});
  @override
  List<String> get props => [userId];
}

class DeleteLogs extends LogEvent {
  final String userId;
  DeleteLogs({required this.userId});
  @override
  List<String> get props => [userId];
}