part of 'subject_bloc.dart';

abstract class SubjectState {
  const SubjectState();

  factory SubjectState.emptyState() => EmptyState();
  // factory SubjectState.changeState() => ChangedSubjectAttendance();
  factory SubjectState.initialState() => SubjectInitalState();
  factory SubjectState.editedState() => SubjectEdited();
  factory SubjectState.deleteSubject() => SubjectDeleted();
}

class EmptyState extends SubjectState {}

// class ChangedSubjectAttendance extends SubjectState {}

class SubjectInitalState extends SubjectState {}

class SubjectEdited extends SubjectState {}

class SubjectDeleted extends SubjectState {}
