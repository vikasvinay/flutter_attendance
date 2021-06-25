import 'package:attendance_app/model/subject_model.dart';
import 'package:attendance_app/repository/attendance_repository.dart';
import 'package:attendance_app/repository/subject_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubJectRepository? subJectRepository = SubJectRepository();
  AttendanceRepository? attendanceRepository = AttendanceRepository();
  SubjectBloc(this.subJectRepository) : super(SubjectState.initialState());

  @override
  Stream<SubjectState> mapEventToState(SubjectEvent event) async* {
    if (event is EmptyEvent) {
      yield EmptyState();
    } else if (event is EditSubject) {
      await subJectRepository!.editSubject(
          subjectId: event.subjectId, subjectModel: event.subjectModel);

      yield SubjectState.editedState();
    } else if (event is InitalSubject) {
      await subJectRepository!.addSubject(subjectName: event.subjectName);

      yield SubjectState.initialState();
    } 
    // else if (event is IncrementPresent) {
    //   await attendanceRepository!.addAttendance(
    //       isPresent: true,
    //       subjectId: event.subjectId,
    //       studentUid: event.studentUid);

    //   yield SubjectState.changeState();
    // } else if (event is IncrementAbsent) {
    //   await attendanceRepository!.addAttendance(
    //       isPresent: false,
    //       subjectId: event.subjectId,
    //       studentUid: event.studentUid);

    //   yield SubjectState.changeState();
    // } 
    else if (event is DeleteSubject) {
      await subJectRepository!.deleteSubject(subjectName: event.subjectName);
      print(event.subjectName);
      yield SubjectState.deleteSubject();
    }
  }
}
