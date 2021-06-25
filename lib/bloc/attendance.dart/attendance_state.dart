part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable{
  const AttendanceState();

  factory AttendanceState.emptyState()=> AttendanceEmptyState();
  factory AttendanceState.addedAttendance()=> ChangedSubjectAttendance();

  @override
  List<Object> get props => [];
}

class AttendanceEmptyState extends AttendanceState{}

class ChangedSubjectAttendance extends AttendanceState {}
