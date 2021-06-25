import 'package:attendance_app/bloc/add_log/log_bloc.dart';
import 'package:attendance_app/bloc/attendance.dart/attendance_bloc.dart';
import 'package:attendance_app/model/student_model.dart';
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

  CommonWidget _commonWidget = CommonWidget();

  MentorRepository _mentorRepository = MentorRepository();
  int timeStamp = DateTime.now().millisecondsSinceEpoch;
  List<bool> checkVal = [];
  List<String> studentUids = [];
  bool can = true;

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
            height: 0.15.sh,
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                Wrap(
                  // spacing: 
                  children: [
                    _subjectSelection(context,
                        title: 'Select Subject:',
                        items: widget.subjectsList,
                        isYear: false),
                    _subjectSelection(context,
                        title: 'Student studentYear: ',
                        items: year,
                        isYear: true),
                  ],
                ),
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
                        studentYear: studentYear, mentorSubjects: subjectName),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (can) {
                        checkVal =
                            List.generate(snap.data!.length, (index) => false);

                        can = false;
                      }

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
                                    setState(() {
                                      checkVal[index] = !checkVal[index];
                                    });
                                    print(checkVal[index]);
                                  }),
                              title: Text(student.name!),
                            );
                          });
                    }),

                // PaginateFirestore(
                //   shrinkWrap: true,
                //   query: FirebaseFirestore.instance
                //       .collection('users')
                //       .where('enrolled_subjects',
                //           arrayContainsAny: widget.subjectsList)
                //       .orderBy('name', descending: true),
                //   itemBuilderType: PaginateBuilderType.listView,
                //   itemBuilder: (int, context, DocumentSnapshot doc) {
                //     StudentModel student = StudentModel.fromFireStore(doc: doc);
                //     if (_mentorBloc.mentorModel!.uid != student.uid) {
                //       return ListTile(
                //         leading: Checkbox(value: true, onChanged: (val) {}),
                //         title: Text(student.name),
                //       );
                //     } else {
                //       return Container();
                //     }
                //   },
                // ),
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

  Widget _subjectSelection(BuildContext context,
      {required String title, required List items, required bool isYear}) {
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
                setState(() {
                  if (!isYear) {
                    subjectName = val as String;
                  }
                  if (isYear) {
                    studentYear = val as String;
                  }
                });
              },
              hint: Text(isYear ? studentYear : subjectName),
            )
          ],
        ),
      );
    });
  }

  void _save(BuildContext context) {
    print('save');
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
