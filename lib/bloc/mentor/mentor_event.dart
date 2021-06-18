part of 'mentor_bloc.dart';

abstract class MentorEvent extends Equatable {
  const MentorEvent();

  factory MentorEvent.fetch() => FetchMentor();

  factory MentorEvent.gotMentor(MentorModel mentorModel) =>
      RecivedMentorData(mentorModel: mentorModel);

  @override
  List<Object> get props => [];
}

class FetchMentor extends MentorEvent {}

class RecivedMentorData extends MentorEvent {
  final MentorModel mentorModel;

  RecivedMentorData({required this.mentorModel});

  @override
  List<MentorModel> get props => [mentorModel];

}
