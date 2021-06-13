part of 'subject_bloc.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  factory SubjectEvent.empty() => EmptyEvent();
  factory SubjectEvent.initalSubject(String subjectName) =>
      InitalSubject(subjectName: subjectName);
  factory SubjectEvent.addSubject(
          String subjectId, SubjectModel subjectModel) =>
      EditSubject(subjectId: subjectId, subjectModel: subjectModel);
  factory SubjectEvent.present(bool isPresent, String subjectId) =>
      IncrementPresent(subjectId: subjectId);
  factory SubjectEvent.absent(bool isPresent, String subjectId) =>
      IncrementAbsent(subjectId: subjectId);
}

class EmptyEvent extends SubjectEvent {
  @override
  List<Object> get props => [];
}

class EditSubject extends SubjectEvent {
  final String subjectId;
  final SubjectModel subjectModel;
  EditSubject({required this.subjectId, required this.subjectModel});

  @override
  List<Object> get props => [subjectId];
}

class InitalSubject extends SubjectEvent {
  final String subjectName;
  InitalSubject({required this.subjectName});

  @override
  List<Object> get props => [subjectName];
}

class IncrementPresent extends SubjectEvent {
  final String subjectId;

  IncrementPresent({required this.subjectId});

  @override
  List<Object> get props => [subjectId];
}

class IncrementAbsent extends SubjectEvent {
  final String subjectId;

  IncrementAbsent({required this.subjectId});

  @override
  List<Object> get props => [subjectId];
}
