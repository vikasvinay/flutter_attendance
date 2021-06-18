import 'package:attendance_app/repository/log_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  LogRepository logRepository = LogRepository();

  LogBloc({required this.logRepository}) : super(LogEmptyState());
  @override
  Stream<LogState> mapEventToState(LogEvent event) async* {
    if (event is LogEmptyState) {
      yield LogEmptyState();
    } else if (event is LogIncrementEvent) {
      await logRepository.createLog(
          subjectName: event.subjectName,
          isPresent: event.isPresent,
          studentUid: event.studentUid,
          timestamp: event.timestamp);
      yield LogIncrementState();
    } else if (event is GetAllLogs) {
      logRepository.getAllLogs(useruid: event.userId);
      yield GotLogs();
    } else if (event is LogSubjectAdd) {
      await logRepository.logSubjectAdd(subjectName: event.subjectName);
      yield Loginitial();
    }
  }
}
