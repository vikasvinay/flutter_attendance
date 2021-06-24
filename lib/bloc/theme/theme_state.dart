part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData appTheme;

  ThemeState({required this.appTheme});
  @override
  List<ThemeData> get props => [appTheme];


}

// class ThemeChanged extends ThemeState {
//   final ThemeData appTheme;

//   ThemeChanged({required this.appTheme});
//   @override
//   List<ThemeData> get props => [appTheme];
// }
