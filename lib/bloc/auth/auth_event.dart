part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  factory AuthEvent.appLaunch() => AppLaunched();
  factory AuthEvent.login(String email, String password) =>
      LoginEvent(email: email, password: password);
  factory AuthEvent.register(
          String email, String password, String name, String stydentYear, String branch) =>
      RegisterEvent(
          email: email,
          branch: branch,
          password: password,
          name: name,
          studentYear: stydentYear);
  factory AuthEvent.logOut() => LogOut();
  factory AuthEvent.invalid() => UserInvalid();
  factory AuthEvent.userLoggedIn() => UserLoggedIn();

  @override
  List<Object> get props => [];
}

class AppLaunched extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<String> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String branch;
  final String email;
  final String password;
  final String name;
  final String studentYear;

  RegisterEvent(
      {required this.email,
      required this.branch,
      required this.name,
      required this.password,
      required this.studentYear});

  @override
  List<String> get props => [email, password, name];
}

class LogOut extends AuthEvent {}

class UserInvalid extends AuthEvent {}

class UserLoggedIn extends AuthEvent {}

class NoUser extends AuthEvent {}
