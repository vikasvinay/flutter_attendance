part of 'subject_bloc.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  factory SubjectEvent.empty() => EmptyEvent();
  factory SubjectEvent.initalSubject(String subjectName) =>
      InitalSubject(subjectName: subjectName);
  factory SubjectEvent.addSubject(
          String subjectId, SubjectModel subjectModel) =>
      EditSubject(subjectId: subjectId, subjectModel: subjectModel);
  // factory SubjectEvent.present(
  //         bool isPresent, String subjectId, String studentUid) =>
  //     IncrementPresent(subjectId: subjectId, studentUid: studentUid);
  // factory SubjectEvent.absent(String studentUid, String subjectId) =>
  //     IncrementAbsent(subjectId: subjectId, studentUid: studentUid);
  factory SubjectEvent.deletSubject(String subjectName) =>
      DeleteSubject(subjectName: subjectName);

  factory SubjectEvent.getAllSubjects(String year, String branch) =>
      GetAllSubjects(branch: branch, year: year);
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

// class IncrementPresent extends SubjectEvent {
//   final String studentUid;
//   final String subjectId;

//   IncrementPresent({required this.subjectId, required this.studentUid});

//   @override
//   List<String> get props => [subjectId, studentUid];
// }

// class IncrementAbsent extends SubjectEvent {
//   final String studentUid;
//   final String subjectId;

//   IncrementAbsent({required this.subjectId, required this.studentUid});

//   @override
//   List<String> get props => [subjectId, studentUid];
// }

class DeleteSubject extends SubjectEvent {
  final String subjectName;
  DeleteSubject({required this.subjectName});

  @override
  List<String> get props => [subjectName];
}

class GetAllSubjects extends SubjectEvent {
  final String year;
  final String branch;
  GetAllSubjects({required this.branch, required this.year});
  @override
  List<String> get props => [year, branch];
}
