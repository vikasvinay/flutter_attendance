part of 'student_bloc.dart';

class StudentEvent extends Equatable {
  const StudentEvent();

  factory StudentEvent.getStudent() => GetStudentEvent();
  factory StudentEvent.emptyEvent() => EmptyEvent();
  factory StudentEvent.gotStudent(StudentModel studentModel) =>
      GotStudentEvent(studentModel: studentModel);

  @override
  List<Object?> get props => [];
}

class EmptyEvent extends StudentEvent {}

class GetStudentEvent extends StudentEvent {}

class GotStudentEvent extends StudentEvent {
  final StudentModel studentModel;

  GotStudentEvent({required this.studentModel});
  @override
  List<StudentModel> get props => [studentModel];
}
