import 'package:cloud_firestore/cloud_firestore.dart';

class AllSubjects {
  String branch;
  String subjectName;
  String subjectCode;
  String year;
  AllSubjects(
      {required this.subjectName,
      required this.branch,
      required this.subjectCode,
      required this.year});

  factory AllSubjects.fromFirestore({required DocumentSnapshot doc}) {
    var data = (doc.data() as dynamic);
    return AllSubjects(
        branch: doc.id,
        subjectName: data['subject_name'],
        subjectCode: doc['subject_code'],
        year: doc.id);
  }
}

class YearSubjects {
  List? subjects;
  List? codes;

  YearSubjects({this.codes, this.subjects});
  factory YearSubjects.fromFirestore({required Map<String, dynamic> map}) {
    return YearSubjects(
        codes: map.values.toList(), subjects: map.keys.toList());
  }
}
