import 'package:attendance_app/bloc/add_log/log_bloc.dart';
import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/bloc/theme/theme_bloc.dart';
import 'package:attendance_app/model/student_model.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/common.dart';
import 'package:attendance_app/ui/common/theme_data/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isDarkMode = false;
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _themeBloc = BlocProvider.of<ThemeBloc>(context);

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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            StudentModel user = StudentModel.fromFireStore(doc: snapshot.data);
            return ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                GestureDetector(
                  onTap: () async {
                    await _commonWidget.imagePicker(uid: user.uid);
                  },
                  child: CircleAvatar(
                    maxRadius: 80.r,
                    backgroundImage: NetworkImage(user.photoUrl!),
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
                  title: Text(user.name),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(user.email),
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
                //   Radio(
                //       value: AppTheme.BlueLight,
                //       groupValue: _appTheme,
                //       onChanged: (AppTheme? val) {
                //         if (val == AppTheme.BlueDark) {
                //           // _themeBloc.add(ChangeThemeEvent(appTheme: AppTheme.values[1]));
                //           setState(() {
                //             _appTheme = val!;
                //           });
                //           print(val);
                //         } else {
                //           // _themeBloc.add(ChangeThemeEvent(appTheme: AppTheme.values[0]));
                //           setState(() {
                //             _appTheme = val!;
                //           });
                //         }
                //       }),
                // ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Log out"),
                  onTap: () {
                    _authBloc.add(LogOut());
                  },
                ),
                Divider(),
                // Spacer(),
                ListTile(
                  title: Center(child: Text("version: 0.01")),
                )
              ],
            );
          }),
    );
  }
}
