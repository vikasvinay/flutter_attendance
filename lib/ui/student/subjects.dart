import 'dart:developer';

import 'package:attendance_app/bloc/add_log/log_bloc.dart';
import 'package:attendance_app/bloc/student/student_bloc.dart';
import 'package:attendance_app/bloc/subject/subject_bloc.dart';
import 'package:attendance_app/model/all_subjects_model.dart';
import 'package:attendance_app/repository/all_subjects_repositort.dart';
import 'package:attendance_app/ui/common/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubjects extends StatefulWidget {
  const StudentSubjects({Key? key}) : super(key: key);

  @override
  _StudentSubjectsState createState() => _StudentSubjectsState();
}

class _StudentSubjectsState extends State<StudentSubjects> {
  AllSubjectsRepository _subjectsRepository = AllSubjectsRepository();
  var subjectesAdded = <String>[];
  late StudentBloc _studentBloc;
  late SubjectBloc _subjectBloc;
  late LogBloc _logBloc;
  // late StudentModel _studentModel;
  bool hasSubjects = false;
  CommonWidget _commonWidget = CommonWidget();
  @override
  void initState() {
    _subjectBloc = BlocProvider.of<SubjectBloc>(context);
    _logBloc = BlocProvider.of<LogBloc>(context);
    _studentBloc = BlocProvider.of<StudentBloc>(context);
    super.initState();
  }

  var boolsList =
      <bool>[]; //List.generate(subjects[0].length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _studentBloc,
      builder: (context, state) {
        if (state is GotStudentState) {
          GotStudentState student = state;
          log('in state');
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                if (student.studentModel.enrolledSubjects!.length >= 1) {
                  _commonWidget
                      .commonToast('Contact admin for add or change subjects');
                } else {
                  _commonWidget.commonToast('Subjects added');
                  _saveSubjects(student);
                }
              },
              label: Text('Save'),
              icon: Icon(Icons.add),
            ),
            appBar: AppBar(
              title: Text('Subjects'),
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                FutureBuilder<YearSubjects>(
                    future: _subjectsRepository.getYearSubjects(
                        year: student.studentModel.studentYear!,
                        branch: student.studentModel.branch!),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        log('error in future builder');

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!hasSubjects) {
                        boolsList = List.generate(
                            snap.requireData.subjects!.length,
                            (index) => false);

                        hasSubjects = true;
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(snap.data!.subjects![index]),
                              subtitle: Text(snap.data!.codes![index]),
                              leading: Checkbox(
                                  value: boolsList[index],
                                  onChanged: (add) {
                                    setState(() {
                                      boolsList[index] = !boolsList[index];
                                    });
                                    subjectesAdded
                                        .add(snap.data!.codes![index]);
                                  }),
                            );
                          });
                    })
              ],
            ),
          );
        } else {
          log('no state');

          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _saveSubjects(GotStudentState student) {
    var set = subjectesAdded.toSet();
    print(subjectesAdded.toSet());
    for (int i = 0; i < set.length; i++) {
      _subjectBloc.add(InitalSubject(subjectName: set.elementAt(i)));
      _logBloc.add(
          LogSubjectAdd(subjectName: "${set.elementAt(i)}\nAdded"));
    }
  }
}
