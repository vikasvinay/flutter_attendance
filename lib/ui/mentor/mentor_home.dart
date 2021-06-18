import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/bloc/mentor/mentor_bloc.dart';
import 'package:attendance_app/model/mentor_model.dart';
import 'package:attendance_app/model/student_model.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MentorHome extends StatefulWidget {
  const MentorHome({Key? key}) : super(key: key);

  @override
  _MentorHomeState createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  late AuthBloc _authBloc;
  late MentorBloc _mentorBloc;
  List? mentorSubject;
  late MentorModel mentor = MentorModel();
  List<String> studentIds = [];
  CommonWidget _commonWidget = CommonWidget();

  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _mentorBloc = BlocProvider.of<MentorBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _mentorBloc,
        builder: (context, state) {
          if (state is FetchedMentor) {
            FetchedMentor _fetch = state;
            return Scaffold(
              drawer: Drawer(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _commonWidget.imagePicker(
                          uid: _fetch.mentorModel.uid!);
                    },
                    child: CircleAvatar(
                      maxRadius: 80.r,
                      backgroundImage:
                          NetworkImage(_fetch.mentorModel.photoUrl!),
                      minRadius: 60.r,
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text(_fetch.mentorModel.name!),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(_fetch.mentorModel.email!),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.timeline_rounded),
                    title: Text('Add attendance'),
                    onTap: () {
                      FluroRouting.fluroRouter.navigateTo(
                          context, PageName.addAttendance,
                          routeSettings: RouteSettings(
                              arguments: _fetch.mentorModel.subjectName!));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Log out"),
                    onTap: () {
                      _authBloc.add(LogOut());
                    },
                  ),
                  Divider(),
                  Spacer(),
                  ListTile(
                    title: Center(child: Text("version: 0.01")),
                  )
                ],
              )),
              appBar: AppBar(
                title: Text('Students'),
              ),
              body: Container(
                  height: 1.sh,
                  width: 1.sw,
                  child: PaginateFirestore(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.6),
                    itemBuilderType: PaginateBuilderType.gridView,
                    isLive: true,
                    shrinkWrap: true,
                    query: FirebaseFirestore.instance
                        .collection('users')
                        .where('enrolled_subjects',
                            arrayContainsAny: _fetch.mentorModel.subjectName!)
                        .orderBy('name', descending: true),
                    itemBuilder: (int, context, DocumentSnapshot doc) {
                      if (state.mentorModel.uid! != doc.get('uid')) {
                        StudentModel student =
                            StudentModel.fromFireStore(doc: doc);
                        print(_fetch.mentorModel.subjectName!);
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                FluroRouting.fluroRouter.navigateTo(
                                    context, PageName.history,
                                    routeSettings: RouteSettings(arguments: [
                                      student.uid,
                                      student.totalAbsent,
                                      student.totalPresent
                                    ]));
                              },
                              child: studentCard(
                                  totalPresent: student.totalPresent,
                                  totalabsent: student.totalAbsent,
                                  mentorId: state.mentorModel.uid!,
                                  studentSubjects: student.enrolledSubjects,
                                  studentId: student.uid,
                                  studentName: student.name,
                                  mentorSubjects:
                                      _fetch.mentorModel.subjectName!),
                            ));
                      } else {
                        return Container();
                      }
                    },
                  )),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Students"),
              ),
              body: Center(
                child: Text("No student enrolled"),
              ),
            );
          }
        });
  }

  Widget studentCard(
      {required String studentName,
      required List mentorSubjects,
      required List studentSubjects,
      required int totalPresent,
      required int totalabsent,
      required String mentorId,
      required String studentId}) {
    if (studentId != mentorId) {
      List subjects = mentorSubjects
          .where((element) => studentSubjects.contains(element))
          .toList();
      studentIds.add(studentId);

      return Material(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          height: 0.8.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.lightBlue,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: $studentName'), //Text(studentName)
                ],
              ),
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Subjects: '),
                      ...List.generate(
                        subjects.length,
                        (index) => Text('${subjects[index]}, '),
                      ), //Text(subjects.toString())
                    ],
                  ),
                ],
              ),
              Text('Total classes: ${totalPresent + totalabsent}'),
              Text('Present: $totalPresent')
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
