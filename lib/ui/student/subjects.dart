import 'package:attendance_app/ui/common/constants.dart';
import 'package:flutter/material.dart';

class StudentSubjects extends StatefulWidget {
  const StudentSubjects({Key? key}) : super(key: key);

  @override
  _StudentSubjectsState createState() => _StudentSubjectsState();
}

class _StudentSubjectsState extends State<StudentSubjects> {
  List<bool> boolsList = List.generate(subjects[0].length, (index) => false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
      ),
      body: ListView.builder(
          itemCount: subjects[0].length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(subjects[0][index]['name']),
                Checkbox(
                    value: boolsList[index],
                    onChanged: (add) {
                      setState(() {
                        boolsList[index] = !boolsList[index];
                      });
                    }),
              ],
            );
          }),
    );
  }
}
