part of 'mentor_bloc.dart';

abstract class MentorState extends Equatable {
  const MentorState();

  factory MentorState.hasData(MentorModel mentorModel) =>
      FetchedMentor(mentorModel: mentorModel);

  @override
  List<Object> get props => [];
}

class InitalMentor extends MentorState {}

class FetchedMentor extends MentorState {
  final MentorModel mentorModel;
  FetchedMentor({required this.mentorModel});

  @override
  List<MentorModel> get props => [mentorModel];
}
