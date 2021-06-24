import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum Year { FIRST, SECOND, THIRD, FORTH }

class _RegisterPageState extends State<RegisterPage> {
  late AuthBloc _authBloc;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  CommonWidget _commonWidget = CommonWidget();
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    selectedYear = year[0];
    super.initState();
  }

  Year _studentyear = Year.FIRST;

  var year = <String>['I', '	II', '	III', '	IV'];
  late String selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 100.h,
          ),
          Center(
              child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 80.sp, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              child: Container(
                height: 0.8.sw,
                width: 0.9.sw,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _commonWidget.textField(
                          controller: _name,
                          hintText: 'name',
                          errorText: 'Invalid name or name is used',
                          icon: Icons.people,
                          validator: '[a-zA-Z]'),
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
                      Builder(builder: (contect) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Year:  ',
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            ...List.generate(
                                Year.values.length,
                                (index) => Row(
                                      children: [
                                        Text('${year[index]}',
                                            style: TextStyle(fontSize: 16.sp)),
                                        Radio<Year>(
                                            value: Year.values[index],
                                            groupValue: _studentyear,
                                            onChanged: (val) {
                                              setState(() {
                                                _studentyear = val!;
                                                selectedYear = year[index];
                                              });
                                            }),
                                      ],
                                    ))
                          ],
                        );
                      }),
                      MaterialButton(
                          color: Colors.lightBlue,
                          child: Text(
                            "Sign Up",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                          onPressed: submit),
                    ],
                  ),
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                FluroRouting.fluroRouter.navigateTo(context, PageName.login);
              },
              child: Text(
                "I'm a user!",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              )),
          BlocBuilder(
              bloc: _authBloc,
              builder: (context, state) {
                if (state is UserError) {
                  _commonWidget.commonToast('Invalid Details or Email not exist',
                      color: Colors.red);
                  return Container();
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }

  void submit() {
    if (_key.currentState!.validate()) {
      _authBloc.add(RegisterEvent(
          studentYear: selectedYear,
          email: _email.text.trim(),
          password: _password.text.trim(),
          name: _name.text.toLowerCase().trim()));
    }
  }
}
