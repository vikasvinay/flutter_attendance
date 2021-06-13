import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/history.dart';
import 'package:attendance_app/ui/mentor/mentor_home.dart';
import 'package:attendance_app/ui/student/student_home.dart';
import 'package:attendance_app/ui/login.dart';
import 'package:attendance_app/ui/signup.dart';
import 'package:attendance_app/ui/super_admin/super_home.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

class FluroRouting {
  static final FluroRouter fluroRouter = FluroRouter();

  Handler _login = Handler(handlerFunc: (context, params) => LoginPage());
  Handler _register = Handler(handlerFunc: (context, params) => RegisterPage());
  Handler _studentHome = Handler(handlerFunc: (context, params) => HomePage());
  Handler _history = Handler(handlerFunc: (context, params) {
    final String data = ModalRoute.of(context!)!.settings.arguments as String;
    return HistoryPage(
      userId: data,
    );
  });
  Handler _mentorHome = Handler(handlerFunc: (context, params) => MentorHome());
  Handler _adminHome = Handler(handlerFunc: (context, params) => Superhome());

  void routeSetup() {
    fluroRouter.define(PageName.login, handler: _login);
    fluroRouter.define(PageName.register, handler: _register);
    fluroRouter.define(PageName.studentHome, handler: _studentHome);
    fluroRouter.define(PageName.history, handler: _history);
    fluroRouter.define(PageName.mentorHome, handler: _mentorHome);
    fluroRouter.define(PageName.superAdminHome, handler: _adminHome);
  }
}
