import 'package:attendance_app/model/student_model.dart';
import 'package:attendance_app/repository/student_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc({StudentState? initialState}) : super(EmptyState());
  StudentRepository _repository = StudentRepository();

  @override
  Stream<StudentState> mapEventToState(StudentEvent event) async* {
    if (event is EmptyEvent) {
      yield StudentState.emptyState();
    } else if (event is GetStudentEvent) {
      _repository.getStudentDetails().listen((data) {
        add(GotStudentEvent(studentModel: data));
        print('GetStudentEvent');
      });
    } else if (event is GotStudentEvent) {
      print('GotStudentEvent');
      print(event.studentModel.email);
      yield StudentState.gotStudent(event.studentModel);
      print('111111111');
    }
  }
}
