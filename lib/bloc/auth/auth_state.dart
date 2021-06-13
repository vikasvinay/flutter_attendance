part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  factory AuthState.inital() => AppInitial();
  factory AuthState.login() => LoggedIn();
  factory AuthState.noUser() => UserNotLoggedIn();
  factory AuthState.error() => UserError();

  @override
  List<Object> get props => [];
}

class AppInitial extends AuthState {}

class LoggedIn extends AuthState {
}

class UserError extends AuthState {}

class UserNotLoggedIn extends AuthState {}
