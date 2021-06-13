import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/repository/auth_repository.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthBloc _authBloc;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  CommonWidget _commonWidget = CommonWidget();
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder(
    //   bloc: _authBloc,
    //   builder: (context, state) {
    //     if (state is UserError) {
    //       return ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text("Error")));
    //     }
    //     throw '';
    //   },
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Center(
              child: Text(
            "Attendance App",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Material(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              child: Container(
                height: 0.8.sw,
                width: 0.9.sw,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 40.r),
                        ),
                      ),
                      _commonWidget.textField(
                          controller: _email,
                          hintText: 'email',
                          icon: Icons.mail,
                          errorText: "Invalid email",
                          validator:
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                      _commonWidget.textField(
                          controller: _password,
                          hintText: 'password',
                          icon: Icons.lock,
                          errorText:
                              "Minimum length 8\nWith A-Z, a-z, 0-9 and !@#\$%^&*~ ",
                          validator:
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
                      MaterialButton(
                          color: Colors.lightBlue,
                          child: Text("Login"),
                          onPressed: submit),
                    ],
                  ),
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              FluroRouting.fluroRouter.navigateTo(context, PageName.register);
            },
            child: Text("Register"),
          )
        ],
      ),
    );
  }

  void submit() {
    if (_key.currentState!.validate()) {
      _authBloc.add(LoginEvent(
          email: _email.text.trim(), password: _password.text.trim()));
    }
  }
}
