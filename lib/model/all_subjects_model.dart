import 'package:cloud_firestore/cloud_firestore.dart';

class AllSubjects {
  String subjectName;
  String subjectCode;
  String year;
  AllSubjects(
      {required this.subjectName,
      required this.subjectCode,
      required this.year});

  factory AllSubjects.fromFirestore({required DocumentSnapshot doc}) {
    var data = (doc.data() as dynamic);
    return AllSubjects(
        subjectName: data['subject_name'],
        subjectCode: doc['subject_code'],
        year: doc.id);
  }
}
