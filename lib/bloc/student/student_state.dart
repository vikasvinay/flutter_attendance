part of 'student_bloc.dart';

class StudentState extends Equatable {
  const StudentState();
  factory StudentState.gotStudent(StudentModel studentModel)=> GotStudentState(studentModel: studentModel);
  factory StudentState.emptyState()=> EmptyState();
  @override
  List<Object?> get props => [];
}
class EmptyState extends StudentState{}
class GotStudentState extends StudentState{
  final StudentModel studentModel;

  GotStudentState({required this.studentModel});

  @override
  List<StudentModel> get props => [studentModel];
}