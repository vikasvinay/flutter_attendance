part of 'log_bloc.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();
  factory LogEvent.empty() => LogEmptyEvent();
  factory LogEvent.increment(String subjectName, bool isPresent) =>
      LogIncrementEvent(isPresent: isPresent, subjectName: subjectName);
  factory LogEvent.getAll(String userId) => GetAllLogs(userId: userId);
  factory LogEvent.addSubject(String subjectName) =>
      LogSubjectAdd(subjectName: subjectName);

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
  List<Object> get props => [];
}

class LogIncrementEvent extends LogEvent {
  final String subjectName;
  final bool isPresent;

  LogIncrementEvent({required this.isPresent, required this.subjectName});
  @override
  List<Object> get props => [subjectName, isPresent];
}

class GetAllLogs extends LogEvent {
  final String userId;
  GetAllLogs({required this.userId});
  @override
  List<Object> get props => [userId];
}
