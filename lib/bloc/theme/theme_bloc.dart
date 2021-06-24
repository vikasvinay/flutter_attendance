import 'package:attendance_app/ui/common/theme_data/themes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({ThemeState? initialState})
      : super(ThemeState(appTheme: themeData[AppTheme.BlueLight]!));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ChangeThemeEvent) {
      yield ThemeState(appTheme: themeData[event.appTheme]!);
    }
  }
  // ThemeBloc({initialState}) : super(themeData[AppTheme.BlueLight]);

  // @override
  // Stream mapEventToState(event) async* {
  // if (event is ChangeThemeEvent) {
  //   yield ThemeChanged(appTheme: themeData[event.appTheme]!);
  // }
  // }
}
