import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MentorHome extends StatefulWidget {
  const MentorHome({Key? key}) : super(key: key);

  @override
  _MentorHomeState createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  late AuthBloc _authBloc;

  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mentor Home"),
        actions: [
          IconButton(
              onPressed: () {
                _authBloc.add(LogOut());
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}
