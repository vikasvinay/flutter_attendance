import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/history.dart';
import 'package:attendance_app/ui/mentor/add_attendance.dart';
import 'package:attendance_app/ui/mentor/mentor_home.dart';
import 'package:attendance_app/ui/student/settings.dart';
import 'package:attendance_app/ui/student/student_home.dart';
import 'package:attendance_app/ui/login.dart';
import 'package:attendance_app/ui/signup.dart';
import 'package:attendance_app/ui/student/subjects.dart';
import 'package:attendance_app/ui/super_admin/super_home.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class FluroRouting {
  static final FluroRouter fluroRouter = FluroRouter();

  Handler _login = Handler(handlerFunc: (context, params) => LoginPage());
  Handler _register = Handler(handlerFunc: (context, params) => RegisterPage());
  Handler _studentHome = Handler(handlerFunc: (context, params) => HomePage());
  Handler _history = Handler(handlerFunc: (context, params) {
    final List data = ModalRoute.of(context!)!.settings.arguments as List;
    return HistoryPage(
      totalAbsent: data[1],
      totalPresent: data[2],
      userId: data[0],
    );
  });
  Handler _mentorHome = Handler(handlerFunc: (context, params) => MentorHome());
  Handler _adminHome = Handler(handlerFunc: (context, params) => Superhome());
  Handler _addAttendance = Handler(handlerFunc: (context, params) {
    final List subjectsList =
        ModalRoute.of(context!)!.settings.arguments as List;
    return AddAttendance(subjectsList: subjectsList);
  });

  Handler _settings = Handler(handlerFunc: (context, params) => Settings());
  Handler _subjects =
      Handler(handlerFunc: (context, params) => StudentSubjects());

  void routeSetup() {
    fluroRouter.define(PageName.login, handler: _login);
    fluroRouter.define(PageName.register, handler: _register);
    fluroRouter.define(PageName.studentHome, handler: _studentHome);
    fluroRouter.define(PageName.history, handler: _history);
    fluroRouter.define(PageName.mentorHome, handler: _mentorHome);
    fluroRouter.define(PageName.superAdminHome, handler: _adminHome);
    fluroRouter.define(PageName.settings, handler: _settings);
    fluroRouter.define(PageName.addAttendance, handler: _addAttendance);
    fluroRouter.define(PageName.subjects, handler: _subjects);
  }
}
