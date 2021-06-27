import 'package:attendance_app/bloc/add_log/log_bloc.dart';
import 'package:attendance_app/bloc/auth/auth_bloc.dart';
import 'package:attendance_app/bloc/student/student_bloc.dart';
import 'package:attendance_app/bloc/subject/subject_bloc.dart';
import 'package:attendance_app/model/subject_model.dart';
import 'package:attendance_app/model/student_model.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/routing/page_name.dart';
import 'package:attendance_app/ui/common/common_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import '../../ui/common/global.dart' as global;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late AuthBloc _authBloc;
  late SubjectBloc _subjectBloc;
  late LogBloc _logBloc;
  TextEditingController _subjectName = TextEditingController();
  CommonWidget _commonWidget = CommonWidget();
  final int pageIndex = 1;
  @override
  void initState() {
    // _authBloc = BlocProvider.of<AuthBloc>(context);
    _subjectBloc = BlocProvider.of<SubjectBloc>(context);
    _logBloc = BlocProvider.of<LogBloc>(context);
    BlocProvider.of<StudentBloc>(context)..add(StudentEvent.getStudent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            FluroRouting.fluroRouter.navigateTo(context, PageName.subjects);
          }, //_popUp,
          label: Text('Subject'),
          icon: Icon(Icons.add),
        ),
        bottomNavigationBar: StreamBuilder(
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
              StudentModel user =
                  StudentModel.fromFireStore(doc: snapshot.data);
              global.totalAbsent = user.totalAbsent!;
              global.totalPresent = user.totalPresent!;
              global.uid = FirebaseAuth.instance.currentUser!.uid;
              print(global.totalPresent);
              return _commonWidget.bottomNavBar(
                context: context,
                pageIndex: pageIndex,
              );
            }),
        // drawer: StudentDrawer(commonWidget: _commonWidget, authBloc: _authBloc),

        appBar: AppBar(
          centerTitle: true,
          title: Text('All Subjects'),
        ),
        body: Container(
            height: 1.sh,
            width: 1.sw,
            child: PaginateFirestore(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemBuilderType: PaginateBuilderType.gridView,
              isLive: true,
              shrinkWrap: true,
              query: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('subjects')
                  .orderBy('timestamp'),
              itemBuilder: (int, context, doc) {
                SubjectModel subject = SubjectModel.fromFirestore(doc: doc);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _attendanceCard(
                      absent: subject.absent!,
                      present: subject.present!,
                      subjectid: subject.subjectId!,
                      subjectName: subject.subjectName!),
                );
              },
            )));
  }

  Future<void> _popUp() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text("Add Subject"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    FluroRouting.fluroRouter.pop(context);
                  },
                  child: Text('Cancle')),
              TextButton(onPressed: _addSubject, child: Text('Ok'))
            ],
            content: Container(
              child: TextFormField(
                controller: _subjectName,
                decoration: InputDecoration(hintText: 'subject'),
                validator: (val) {
                  return RegExp('[a-zA-Z]').hasMatch(val!)
                      ? null
                      : 'Wrong subject name';
                },
              ),
            ),
          );
        });
  }

  Widget _attendanceCard({
    required String subjectName,
    required String subjectid,
    required int absent,
    required int present,
  }) {
    void _deleteSubject() {
      _subjectBloc
          .add(SubjectEvent.deletSubject(subjectName.trim()));
      _commonWidget
          .commonToast('You have deleted ${subjectName.trim()}');
      _logBloc.add(
          LogEvent.addSubject('${subjectName.toUpperCase().trim()}\nDeleted'));
    }

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.all(Radius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.only(left: 10.h),
        height: 0.8.sw,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    subjectName.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle1!..fontSize,
                  ),
                ),
                // Spacer(),
                // IconButton(
                //     onPressed: _deleteSubject,
                //     icon: Icon(
                //       Icons.delete,
                //       size: 18,
                //     ))
              ],
            ),
            // ListTile(
            //   title: Center(child: Text(subjectName.toUpperCase())),
            //   trailing: IconButton(onPressed: _deleteSubject, icon: Icon(Icons.delete, size: 15,)),
            // ),
            Text("Attendance"),
            Text('$present/${present + absent}'),
            CircleAvatar(
              backgroundColor: Colors.lightBlue,
              radius: 50.r,
              child: Text(
                '${(present / (present + absent) * 100).toStringAsFixed(1)}%',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       OutlinedButton(
            //         style: OutlinedButton.styleFrom(shape: StadiumBorder()),
            //         onPressed: () {
            //           _subjectBloc.add(IncrementPresent(subjectId: subjectid));
            //           _logBloc.add(LogIncrementEvent(
            //               isPresent: true, subjectName: subjectName));
            //         },
            //         child: Icon(
            //           Icons.add,
            //           size: 20,
            //         ),
            //       ),
            //       Text("- - -"),
            //       OutlinedButton(
            //         style: OutlinedButton.styleFrom(shape: StadiumBorder()),
            //         onPressed: () {
            //           if ((absent + present) != 0) {
            //             _subjectBloc.add(IncrementAbsent(subjectId: subjectid));
            //             _logBloc.add(LogIncrementEvent(
            //                 isPresent: false, subjectName: subjectName));
            //           }
            //         },
            //         child: Icon(
            //           Icons.remove,
            //           size: 20,
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> _addSubject() async {
    _subjectBloc.add(InitalSubject(subjectName: _subjectName.text));
    _logBloc.add(LogSubjectAdd(subjectName: _subjectName.text));
    FluroRouting.fluroRouter.pop(context);
  }
}

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({
    Key? key,
    required CommonWidget commonWidget,
    required AuthBloc authBloc,
  })  : _commonWidget = commonWidget,
        _authBloc = authBloc,
        super(key: key);

  final CommonWidget _commonWidget;
  final AuthBloc _authBloc;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
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
                    await _commonWidget.imagePicker(uid: user.uid!);
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
                  title: Text(user.name!),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(user.email!),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.timeline_rounded),
                  title: Text('History'),
                  onTap: () {
                    FluroRouting.fluroRouter.navigateTo(
                        context, PageName.history,
                        routeSettings: RouteSettings(arguments: [
                          FirebaseAuth.instance.currentUser!.uid,
                          user.totalAbsent,
                          user.totalPresent
                        ]));
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
