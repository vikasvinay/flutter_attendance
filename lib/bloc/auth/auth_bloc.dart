import 'dart:async';
import 'dart:developer';

import 'package:attendance_app/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;
  StreamSubscription? streamSubscription;

  AuthBloc(this.authRepository) : super(AuthState.inital());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppLaunched) {
      streamSubscription?.cancel();
      streamSubscription =
          FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          add(NoUser());
        } else {
          log(FirebaseAuth.instance.currentUser!.uid);
        }
      });
      if (FirebaseAuth.instance.currentUser != null) {
        yield LoggedIn();
      }
    } else if (event is LoginEvent) {
      bool toNext = await authRepository.loginWithEmail(
          email: event.email, password: event.password);
      if (toNext) {
        print("user logged in-----LoginEvent");
        yield LoggedIn();
      } else {
        print("error----LoginEvent");

        yield UserError();
      }
    } else if (event is RegisterEvent) {
      bool isNext = await authRepository.register(
          type: 'STUDENT',
          name: event.name,
          email: event.email,
          password: event.password);
      if (isNext) {
        print("user logged in-------RegisterEvent");

        yield LoggedIn();
      } else {
        print("error----RegisterEvent");
        yield UserError();
      }
    } else if (event is LogOut) {
      await authRepository.logOut();
      yield UserNotLoggedIn();
    } else if (event is UserLoggedIn) {
      print("user logged in");

      yield LoggedIn();
    } else if (event is NoUser) {
      yield UserNotLoggedIn();
    }
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
