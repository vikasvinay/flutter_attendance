import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/repository/auth_repository.dart';
import 'package:attendance_app/ui/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Superhome extends StatefulWidget {
  const Superhome({Key? key}) : super(key: key);

  @override
  _SuperhomeState createState() => _SuperhomeState();
}

class _SuperhomeState extends State<Superhome> {
  late AuthBloc _authBloc;
  CommonWidget _commonWidget = CommonWidget();
  TextEditingController _mentorName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _subjects = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  AuthRepository _authRepository = AuthRepository();
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home"),
        actions: [
          IconButton(
              onPressed: () {
                _authBloc.add(LogOut());
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 1.sw,
            width: 0.9.sw,
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _commonWidget.textField(
                      controller: _mentorName,
                      icon: Icons.perm_identity,
                      hintText: 'name',
                      validator: '[a-zA-Z]',
                      errorText: 'enter correct name'),
                  _commonWidget.textField(
                      controller: _email,
                      icon: Icons.email,
                      hintText: 'email',
                      validator:
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      errorText: 'enter correct email'),
                  _commonWidget.textField(
                      controller: _password,
                      icon: Icons.lock,
                      hintText: 'password',
                      validator:
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                      errorText:
                          'Minimum length 8\nWith A-Z, a-z, 0-9 and !@#\$%^&*~ "'),
                  // _commonWidget.textField(
                  //     controller: _subjects,
                  //     icon: Icons.book,
                  //     hintText: 'subjects',
                  //     validator: r'^[a-zA-Z, ]+$',
                  //     errorText: 'enter subjects'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.book),
                      Container(
                        width: 0.7.sw,
                        // height: 0.1.sh,
                        child: TextFormField(
                          validator: (val) {
                            return val!.length > 3 ? null : 'enter subjects';
                          },
                          controller: _subjects,
                          decoration: InputDecoration(
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.all(Radius.circular(20.r)),
                              // ),
                              hintText: 'subjects'),
                        ),
                      ),
                    ],
                  ),

                  MaterialButton(
                      color: Colors.lightBlue,
                      child: Text("Sign Up"),
                      onPressed: create),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Note: subject should be separated as eg(RAS301, RCS702)",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void create() async {
    if (_key.currentState!.validate()) {
      print('has match');
      List<String> subjects = _subjects.text.split(',');
      List<String> data = [];
      for (int i = 0; i < subjects.length; i++) {
        data.add(subjects[i].trim());
      }
      await _authRepository
          .cerateMentor(
              email: _email.text,
              password: _password.text,
              mentorName: _mentorName.text,
              subjects: data)
          .then((value) {
        _commonWidget.commonToast('You have created a mentor');
        clear();
      });
    } else {
      print('error');
    }
  }

  void clear() {
    _email.clear();
    _password.clear();
    _mentorName.clear();
    _subjects.clear();
  }
}
