import 'package:attendance_app/bloc/add_log/log_bloc.dart';
import 'package:attendance_app/bloc/attendance/attendance_bloc.dart';
import 'package:attendance_app/model/student_model.dart';
import 'package:attendance_app/repository/all_subjects_repositort.dart';
import 'package:attendance_app/repository/mentor_repository.dart';
import 'package:attendance_app/routing/fluro_route.dart';
import 'package:attendance_app/ui/common/common_widget.dart';
import 'package:attendance_app/ui/common/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAttendance extends StatefulWidget {
  final List subjectsList;
  const AddAttendance({Key? key, required this.subjectsList}) : super(key: key);

  @override
  _AddAttendanceState createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  late LogBloc _logBloc;
  late String subjectName;
  late String studentYear;
  late AttendanceBloc _attendanceBloc;
  AllSubjectsRepository _allSubjectsRepository = AllSubjectsRepository();

  CommonWidget _commonWidget = CommonWidget();

  MentorRepository _mentorRepository = MentorRepository();
  int timeStamp = DateTime.now().millisecondsSinceEpoch;
  List<bool> checkVal = [];
  List<String> studentUids = [];

  String branchSelected = 'IT';

  bool can = true;
  int studentsList = 0;

  @override
  void initState() {
    _logBloc = BlocProvider.of<LogBloc>(context);
    _attendanceBloc = BlocProvider.of<AttendanceBloc>(context);
    subjectName = widget.subjectsList[0];
    studentYear = year[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.subjectsList);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _save(context);
        },
        label: Text('Save'),
        icon: Icon(Icons.save),
      ),
      appBar: AppBar(
        title: Text("Add attendance"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: 0.2.sh,
            color: Theme.of(context).cardColor,
            child: Wrap(
              direction: Axis.vertical,
              children: [
                _dropDown(context,
                    title: 'Select Subject:',
                    items: widget.subjectsList,
                    isbranch: false,
                    isSubject: true,
                    isYear: false),
                _dropDown(context, title: 'Year: ', items: year, isYear: true),
                FutureBuilder<List<String>>(
                    future: _allSubjectsRepository.getonlyBranchs(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return _dropDown(context,
                          title: 'Branch',
                          items: snapshot.requireData,
                          isbranch: true,
                          isYear: false);
                    }),
                _dateTimePicker()
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text('Present: '),
                          Checkbox(value: true, onChanged: null)
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('Absent: '),
                          Checkbox(value: false, onChanged: null)
                        ],
                      ),
                    ),
                  ],
                ),
                FutureBuilder<List<StudentModel>>(
                    future: _mentorRepository.getStudents(
                        branch: branchSelected,
                        studentYear: studentYear,
                        mentorSubjects: subjectName),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      studentsList = snap.data!.length;

                      if (can) {
                        checkVal = List.generate(
                            snap.data!.length == 0 ? 1 : snap.data!.length,
                            (index) => false);
                      }

                      print("$studentsList------------${checkVal.length}");
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data!.length,
                          itemBuilder: (context, index) {
                            StudentModel student = snap.data![index];
                            studentUids.add(student.uid!);
                            return ListTile(
                              leading: Checkbox(
                                  value: checkVal[index],
                                  onChanged: (val) {
                                    can = false;

                                    setState(() {
                                      checkVal[index] = !checkVal[index];
                                    });
                                  }),
                              title: Text(student.name!),
                            );
                          });
                    }),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Select Date:"),
        SizedBox(
          width: 10.h,
        ),
        Container(
          width: 120.w,
          child: DateTimePicker(
            use24HourFormat: false,
            type: DateTimePickerType.dateTime,
            initialValue: DateTime.now().toString(),
            firstDate: DateTime(2018),
            lastDate: DateTime(2100),
            onChanged: (val) {
              setState(() {
                timeStamp = DateTime.parse(val).millisecondsSinceEpoch;
              });
              print(
                  'onSaved: $val,fireStore time $timeStamp , now:${DateTime.fromMillisecondsSinceEpoch(timeStamp)}');
            },
            validator: (val) {
              print('validator: $val');
              return null;
            },
            onSaved: (val) {
              print(DateTime.now());
              return print('onSaved: $val, now:${DateTime.now()}');
            },
          ),
        )
      ],
    );
  }

  Widget _dropDown(BuildContext context,
      {required String title,
      required List items,
      required bool isYear,
      bool isSubject = false,
      bool isbranch = false}) {
    return Builder(builder: (context) {
      return Container(
        child: Row(
          children: [
            Text(title),
            SizedBox(
              width: 10.h,
            ),
            DropdownButton<String>(
              items: items.map<DropdownMenuItem<String>>((val) {
                return DropdownMenuItem(
                    value: val,
                    child: Text(val, style: TextStyle(color: Colors.black)));
              }).toList(),
              onChanged: (val) {
                // can = true;

                // checkVal.clear();

                setState(() {
                  if (isSubject) {
                    subjectName = val as String;
                  }
                  if (isbranch) {
                    branchSelected = val as String;
                  }
                  if (isYear) {
                    studentYear = val as String;
                  }
                });
                studentUids = [];
              },
              hint: isbranch
                  ? Text(branchSelected)
                  : isSubject
                      ? Text(subjectName)
                      : Text(studentYear),
            )
          ],
        ),
      );
    });
  }

  void _save(BuildContext context) {
    print('save');
    // print({checkVal.length, studentUids.toSet().toList().length});
    // print(studentUids.toSet());
    for (int i = 0; i < studentUids.toSet().toList().length; i++) {
      print({checkVal[i], studentUids[i], subjectName, timeStamp});
      if (checkVal[i]) {
        _attendanceBloc.add(IncrementPresent(
            subjectId: subjectName, studentUid: studentUids[i]));
      } else if (!checkVal[i]) {
        _attendanceBloc.add(IncrementAbsent(
            subjectId: subjectName, studentUid: studentUids[i]));
      }
      _logBloc.add(LogIncrementEvent(
          isPresent: checkVal[i],
          studentUid: studentUids[i],
          subjectName: subjectName,
          timestamp: timeStamp));
    }
    _commonWidget.commonToast('You have added attendance');

    FluroRouting.fluroRouter.pop(context);
  }
}
