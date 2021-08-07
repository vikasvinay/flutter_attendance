import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/bloc/student/student_bloc.dart';
import 'package:attendance_app/bloc/theme/theme_bloc.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/common_widget.dart';
import 'package:attendance_app/ui/common/theme_data/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final CommonWidget _commonWidget = CommonWidget();
  final int pageIndex = 2;
  late AuthBloc _authBloc;
  late ThemeBloc _themeBloc;
  late StudentBloc _studentBloc;
  bool isDarkMode = false;
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    _studentBloc = BlocProvider.of<StudentBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          _commonWidget.bottomNavBar(context: context, pageIndex: pageIndex),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocBuilder(
          bloc: _studentBloc,
          builder: (context, state) {
            if (state is GotStudentState) {
              GotStudentState user = state;
              return ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _commonWidget.imagePicker(
                          uid: user.studentModel.uid!);
                    },
                    child: CircleAvatar(
                      maxRadius: 80.r,
                      backgroundImage:
                          NetworkImage(user.studentModel.photoUrl!),
                      minRadius: 60.r,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text(user.studentModel.name!),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(user.studentModel.email!),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.timeline_rounded),
                    title: Text('Dark mode'),
                    trailing: Switch(
                        value: isDarkMode,
                        onChanged: (val) {
                          print(AppTheme.values[0]);
                          if (isDarkMode) {
                            _themeBloc.add(
                                ChangeThemeEvent(appTheme: AppTheme.values[0]));
                            setState(() {
                              isDarkMode = false;
                            });
                          } else {
                            _themeBloc.add(
                                ChangeThemeEvent(appTheme: AppTheme.values[1]));
                            setState(() {
                              isDarkMode = true;
                            });
                          }
                        }),
                  ),
                  // Divider(),
                  // ListTile(
                  //   leading: Icon(Icons.book),
                  //   title: Text('Subjects'),
                  //   onTap: () {
                  //     FluroRouting.fluroRouter
                  //         .navigateTo(context, PageName.subjects);
                  //   },
                  // ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Log out"),
                    onTap: () {
                      _authBloc.add(LogOut());
                      _themeBloc
                          .add(ChangeThemeEvent(appTheme: AppTheme.values[0]));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Center(child: Text("version: 0.01")),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
