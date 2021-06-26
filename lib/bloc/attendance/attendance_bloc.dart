import 'package:attendance_app/repository/attendance_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_state.dart';
part 'attendance_event.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceRepository? attendanceRepository = AttendanceRepository();

  AttendanceBloc(this.attendanceRepository) : super(AttendanceEmptyState());

  @override
  Stream<AttendanceState> mapEventToState(AttendanceEvent event) async* {
    if (event is IncrementPresent) {
      await attendanceRepository!.addAttendance(
          isPresent: true,
          subjectId: event.subjectId,
          studentUid: event.studentUid);

      yield AttendanceState.addedAttendance();
    } else if (event is IncrementAbsent) {
      await attendanceRepository!.addAttendance(
          isPresent: false,
          subjectId: event.subjectId,
          studentUid: event.studentUid);

      yield AttendanceState.addedAttendance();
    } else {
      yield AttendanceEmptyState();
    }
  }
}
