import 'package:attendance_app/model/subject_model.dart';
import 'package:attendance_app/repository/log_repository.dart';
import 'package:attendance_app/repository/subject_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubJectRepository? subJectRepository = SubJectRepository();
  LogRepository _logRepository = LogRepository();
  SubjectBloc(this.subJectRepository) : super(SubjectState.initialState());

  @override
  Stream<SubjectState> mapEventToState(SubjectEvent event) async* {
    if (event is EmptyEvent) {
      yield EmptyState();
    } else if (event is EditSubject) {
      await subJectRepository!.editSubject(
          subjectId: event.subjectId, subjectModel: event.subjectModel);

      yield SubjectEdited();
    } else if (event is InitalSubject) {
      await subJectRepository!.addSubject(subjectName: event.subjectName);

      yield SubjectInitalState();
    } else if (event is IncrementPresent) {
      await subJectRepository!
          .addAttendance(isPresent: true, subjectId: event.subjectId);

      yield ChangedSubjectAttendance();
    } else if (event is IncrementAbsent) {
      await subJectRepository!
          .addAttendance(isPresent: false, subjectId: event.subjectId);

      yield ChangedSubjectAttendance();
    }
  }
}
