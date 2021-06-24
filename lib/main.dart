import 'dart:developer';

import 'package:attendance_app/bloc/add_log/log_bloc.dart';
import 'package:attendance_app/bloc/add_subject/subject_bloc.dart';
import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/bloc/mentor/mentor_bloc.dart';
import 'package:attendance_app/bloc/theme/theme_bloc.dart';
import 'package:attendance_app/model/user_model.dart';
import 'package:attendance_app/repository/auth_repository.dart';
import 'package:attendance_app/repository/log_repository.dart';
import 'package:attendance_app/repository/mentor_repository.dart';
import 'package:attendance_app/repository/subject_repository.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/ui/mentor/mentor_home.dart';
import 'package:attendance_app/ui/student/student_home.dart';
import 'package:attendance_app/ui/login.dart';
import 'package:attendance_app/ui/super_admin/super_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MultiBlocProvider(providers: [
    BlocProvider<ThemeBloc> (create: (context)=> ThemeBloc(),),
    BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(AuthRepository())..add(AppLaunched())),
    BlocProvider<SubjectBloc>(
      create: (context) => SubjectBloc(SubJectRepository())..add(EmptyEvent()),
    ),
    BlocProvider<LogBloc>(
      create: (context) =>
          LogBloc(logRepository: LogRepository())..add(LogEmptyEvent()),
    ),
    
    BlocProvider<MentorBloc>(
      create: (context) => MentorBloc(MentorRepository())..add(FetchMentor()),
    )
  ], child: Core()));
}

class Core extends StatefulWidget {
  const Core({Key? key}) : super(key: key);

  @override
  _CoreState createState() => _CoreState();
}

class _CoreState extends State<Core> {
  late AuthBloc _authBloc;
  late ThemeBloc _themeBloc;
  @override
  void initState() {
    FluroRouting().routeSetup();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: () {
      return BlocBuilder<ThemeBloc, ThemeState>(
        // bloc: _themeBloc,
        builder: (context, themeState) {
          print(themeState);
          print('`````````````````````````');
          ThemeData theme  = themeState.appTheme ;
          return MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: FluroRouting.fluroRouter.generator,
            home: BlocBuilder(
              bloc: _authBloc,
              builder: (context, loginState) {
                if (loginState is LoggedIn) {
                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          UserModel user = UserModel.fromFireStore(
                              doc: snap.data as DocumentSnapshot);
                          log('UID: ${FirebaseAuth.instance.currentUser!.uid}');

                          log('LOGIN TYPE: ${user.type}');
                          if (user.type == 'STUDENT') {
                            return HomePage();
                          } else if (user.type == 'MENTOR') {
                            return MentorHome();
                          } else if (user.type == 'ADMIN') {
                            return Superhome();
                          } else {
                            _authBloc.add(LogOut());
                            return LoginPage();
                          }
                        }
                      });
                } else {
                  return LoginPage();
                }
              },
            ),
          );
        },
      );
    });
  }
}
