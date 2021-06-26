
import 'package:attendance_app/model/mentor_model.dart';
import 'package:attendance_app/repository/mentor_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'mentor_state.dart';
part 'mentor_event.dart';


class MentorBloc extends Bloc<MentorEvent, MentorState>{
  MentorRepository mentorRepository;
  MentorModel? mentorModel;

  MentorBloc(this.mentorRepository): super(InitalMentor());
  @override
  Stream<MentorState> mapEventToState(MentorEvent event) async*{
    // if(event is EmptyMentor){
    //   yield InitalMentor();
    // }
     if(event is FetchMentor){
      mentorRepository.getMentorData().listen((event) {
        mentorModel = event;
       add(RecivedMentorData(mentorModel: event));

       });
    }
    else if(event is RecivedMentorData){
      yield FetchedMentor(mentorModel: event.mentorModel);
    }
  }
}